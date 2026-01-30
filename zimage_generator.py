#!/usr/bin/env python3
"""
Z-Image Turbo Generator - Async Batch Generation

Z-Image Turbo excels at rendering text in images. Follow these prompting guidelines:

TEXT PROMPTING RULES:
=====================
1. Put text in QUOTES: "YOUR TEXT HERE"
2. Describe text position: "at top", "at bottom", "in center", "overlay"
3. Describe text style: "bold", "large", "clean typography", "neon", "handwritten"
4. Separate multiple text elements clearly in the prompt
5. Include the word "text" or "says" to signal text rendering

PROMPT STRUCTURE:
=================
[Subject description], [text element 1] says "TEXT1" [position],
[text element 2] says "TEXT2" [position], [style keywords]

EXAMPLES:
=========
Good: 'Anime girl excited, large bold text "OH MY GOD" at top, text "I CAN\'T BELIEVE IT\'S FREE" at bottom, clean typography'
Good: 'Marketing banner, headline text says "SALE" in red, subtitle "50% OFF" below, gradient background'
Bad:  'Anime girl with OH MY GOD text' (text not in quotes, no position)
"""

import time
import argparse
import sys
import asyncio
import aiohttp
from concurrent.futures import ThreadPoolExecutor
from typing import List, Dict, Optional, Tuple
from dataclasses import dataclass

COMFYUI_URL = "http://71.112.215.60:8188"

# Common aspect ratios
SIZES = {
    "square": (1024, 1024),
    "portrait": (768, 1344),      # Phone splash
    "landscape": (1344, 768),     # Banner
    "wide": (1536, 640),          # Ultra-wide banner
    "phone": (1080, 1920),        # Phone screen
    "instagram": (1080, 1080),    # Instagram post
    "story": (1080, 1920),        # Instagram/TikTok story
}


@dataclass
class Job:
    prompt: str
    filename_prefix: str
    width: int = 1024
    height: int = 1024
    seed: Optional[int] = None


def build_workflow(prompt: str, filename_prefix: str, width: int, height: int, seed: int) -> dict:
    """Build Z-Image Turbo workflow."""
    return {
        "1": {
            "class_type": "UNETLoader",
            "inputs": {"unet_name": "z_image_turbo_bf16.safetensors", "weight_dtype": "default"}
        },
        "2": {
            "class_type": "CLIPLoader",
            "inputs": {"clip_name": "qwen_3_4b.safetensors", "type": "lumina2"}
        },
        "3": {
            "class_type": "VAELoader",
            "inputs": {"vae_name": "ae.safetensors"}
        },
        "4": {
            "class_type": "CLIPTextEncode",
            "inputs": {"clip": ["2", 0], "text": prompt}
        },
        "5": {
            "class_type": "ConditioningZeroOut",
            "inputs": {"conditioning": ["4", 0]}
        },
        "6": {
            "class_type": "EmptySD3LatentImage",
            "inputs": {"width": width, "height": height, "batch_size": 1}
        },
        "7": {
            "class_type": "KSampler",
            "inputs": {
                "model": ["1", 0],
                "positive": ["4", 0],
                "negative": ["5", 0],
                "latent_image": ["6", 0],
                "seed": seed,
                "steps": 4,
                "cfg": 1.0,
                "sampler_name": "res_multistep",
                "scheduler": "simple",
                "denoise": 1.0
            }
        },
        "8": {
            "class_type": "VAEDecode",
            "inputs": {"samples": ["7", 0], "vae": ["3", 0]}
        },
        "9": {
            "class_type": "SaveImage",
            "inputs": {"images": ["8", 0], "filename_prefix": filename_prefix}
        }
    }


async def submit_job(session: aiohttp.ClientSession, job: Job) -> Tuple[str, str, Job]:
    """Submit a job to ComfyUI, return (prompt_id, status, job)."""
    seed = job.seed if job.seed else int(time.time() * 1000) % 2147483647
    workflow = build_workflow(job.prompt, job.filename_prefix, job.width, job.height, seed)

    try:
        async with session.post(f"{COMFYUI_URL}/prompt", json={"prompt": workflow}) as r:
            if r.status != 200:
                text = await r.text()
                return (None, f"Submit error: {text[:100]}", job)
            data = await r.json()
            return (data.get('prompt_id'), "submitted", job)
    except Exception as e:
        return (None, f"Connection error: {e}", job)


async def check_completion(session: aiohttp.ClientSession, prompt_id: str) -> Tuple[str, Optional[str]]:
    """Check if job is complete. Returns (status, filename)."""
    try:
        async with session.get(f"{COMFYUI_URL}/history/{prompt_id}") as r:
            hist = await r.json()
    except:
        return ("pending", None)

    if prompt_id not in hist:
        return ("pending", None)

    entry = hist[prompt_id]

    if entry.get('status', {}).get('status_str') == 'error':
        msgs = entry.get('status', {}).get('messages', [])
        for m in msgs:
            if m[0] == 'execution_error':
                return (f"error: {m[1].get('exception_message', '')[:80]}", None)
        return ("error", None)

    outputs = entry.get('outputs', {})
    if outputs:
        for out in outputs.values():
            if 'images' in out:
                return ("done", out['images'][0]['filename'])

    return ("running", None)


async def run_batch(jobs: List[Job], max_concurrent: int = 4) -> List[dict]:
    """
    Run multiple jobs concurrently.

    Args:
        jobs: List of Job objects
        max_concurrent: Max jobs to run at once (default 4)

    Returns:
        List of result dicts with keys: prompt, filename_prefix, status, output
    """
    results = []
    pending = {}  # prompt_id -> job

    async with aiohttp.ClientSession() as session:
        job_queue = list(jobs)

        while job_queue or pending:
            # Submit new jobs up to max_concurrent
            while job_queue and len(pending) < max_concurrent:
                job = job_queue.pop(0)
                prompt_id, status, job = await submit_job(session, job)

                if prompt_id:
                    pending[prompt_id] = job
                    print(f"[SUBMITTED] {job.filename_prefix}: {job.prompt[:50]}...")
                else:
                    print(f"[FAILED] {job.filename_prefix}: {status}")
                    results.append({
                        "prompt": job.prompt,
                        "filename_prefix": job.filename_prefix,
                        "status": "error",
                        "output": None,
                        "error": status
                    })

            # Check pending jobs
            if pending:
                await asyncio.sleep(1)
                completed = []

                for prompt_id, job in pending.items():
                    status, filename = await check_completion(session, prompt_id)

                    if status == "done":
                        print(f"[DONE] {job.filename_prefix} -> {filename}")
                        results.append({
                            "prompt": job.prompt,
                            "filename_prefix": job.filename_prefix,
                            "status": "done",
                            "output": filename,
                            "url": f"http://71.112.215.60:8188/view?filename={filename}&type=output"
                        })
                        completed.append(prompt_id)
                    elif status.startswith("error"):
                        print(f"[ERROR] {job.filename_prefix}: {status}")
                        results.append({
                            "prompt": job.prompt,
                            "filename_prefix": job.filename_prefix,
                            "status": "error",
                            "output": None,
                            "error": status
                        })
                        completed.append(prompt_id)

                for pid in completed:
                    del pending[pid]

    return results


def generate_single(prompt: str, filename_prefix: str = "zimage",
                    width: int = 1024, height: int = 1024, seed: int = None) -> Optional[str]:
    """Synchronous single image generation. Returns filename or None."""
    job = Job(prompt=prompt, filename_prefix=filename_prefix, width=width, height=height, seed=seed)
    results = asyncio.run(run_batch([job], max_concurrent=1))
    if results and results[0]["status"] == "done":
        return results[0]["output"]
    return None


def generate_batch(jobs: List[Dict], max_concurrent: int = 4) -> List[dict]:
    """
    Generate multiple images concurrently.

    Args:
        jobs: List of dicts with keys: prompt, filename_prefix, width, height, seed (optional)
        max_concurrent: Max concurrent generations

    Returns:
        List of result dicts

    Example:
        jobs = [
            {"prompt": 'Girl with text "HI" at top', "filename_prefix": "img1", "width": 768, "height": 1344},
            {"prompt": 'Cat with text "MEOW"', "filename_prefix": "img2"},
        ]
        results = generate_batch(jobs, max_concurrent=4)
    """
    job_objects = [
        Job(
            prompt=j["prompt"],
            filename_prefix=j.get("filename_prefix", f"zimage_{i}"),
            width=j.get("width", 1024),
            height=j.get("height", 1024),
            seed=j.get("seed")
        )
        for i, j in enumerate(jobs)
    ]
    return asyncio.run(run_batch(job_objects, max_concurrent=max_concurrent))


# ============================================================================
# CLI Interface
# ============================================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Z-Image Turbo Generator - Async batch image generation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
SINGLE IMAGE:
  python zimage_generator.py "Anime girl with text 'HELLO' at top"
  python zimage_generator.py -s portrait -o splash 'Girl with text "WOW" overlay'

BATCH MODE (from file):
  python zimage_generator.py --batch prompts.txt -c 4

  prompts.txt format (one per line):
    output_name | prompt text here
    splash1 | Anime girl, text "OH MY GOD" at top
    banner1 | Marketing banner, text "SALE" center

BATCH MODE (inline):
  python zimage_generator.py --jobs '[
    {"prompt": "Girl with text \\"HI\\"", "filename_prefix": "img1"},
    {"prompt": "Cat with text \\"MEOW\\"", "filename_prefix": "img2"}
  ]'

TEXT TIPS:
  - Always put text in "quotes" in your prompt
  - Specify position: at top, at bottom, in center, overlay
  - Describe style: bold, neon, handwritten, clean typography
        """
    )
    parser.add_argument("prompt", nargs="?", help="Image prompt (for single image mode)")
    parser.add_argument("-o", "--output", default="zimage", help="Output filename prefix")
    parser.add_argument("-s", "--size", default="square", help="Size: square/portrait/landscape/phone/story or WxH")
    parser.add_argument("--seed", type=int, help="Random seed")
    parser.add_argument("--batch", type=str, help="Batch file (one prompt per line: name | prompt)")
    parser.add_argument("--jobs", type=str, help="JSON array of job dicts")
    parser.add_argument("-c", "--concurrent", type=int, default=4, help="Max concurrent jobs (default 4)")

    args = parser.parse_args()

    # Parse size
    if "x" in args.size.lower():
        w, h = args.size.lower().split("x")
        width, height = int(w), int(h)
    else:
        width, height = SIZES.get(args.size, (1024, 1024))

    # Batch mode from file
    if args.batch:
        jobs = []
        with open(args.batch) as f:
            for i, line in enumerate(f):
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if "|" in line:
                    name, prompt = line.split("|", 1)
                    jobs.append({"prompt": prompt.strip(), "filename_prefix": name.strip(), "width": width, "height": height})
                else:
                    jobs.append({"prompt": line, "filename_prefix": f"zimage_{i}", "width": width, "height": height})

        print(f"Running {len(jobs)} jobs with max {args.concurrent} concurrent...\n")
        results = generate_batch(jobs, max_concurrent=args.concurrent)

        print(f"\n{'='*60}")
        print(f"COMPLETE: {sum(1 for r in results if r['status'] == 'done')}/{len(results)} succeeded")
        for r in results:
            if r["status"] == "done":
                print(f"  {r['filename_prefix']}: {r['url']}")

    # Batch mode from JSON
    elif args.jobs:
        import json
        jobs = json.loads(args.jobs)
        for j in jobs:
            j.setdefault("width", width)
            j.setdefault("height", height)

        print(f"Running {len(jobs)} jobs with max {args.concurrent} concurrent...\n")
        results = generate_batch(jobs, max_concurrent=args.concurrent)

        print(f"\n{'='*60}")
        print(f"COMPLETE: {sum(1 for r in results if r['status'] == 'done')}/{len(results)} succeeded")
        for r in results:
            if r["status"] == "done":
                print(f"  {r['filename_prefix']}: {r['url']}")

    # Single image mode
    elif args.prompt:
        result = generate_single(args.prompt, args.output, width, height, args.seed)
        if result:
            print(f"\nOutput: http://71.112.215.60:8188/view?filename={result}&type=output")
        else:
            sys.exit(1)

    else:
        parser.print_help()

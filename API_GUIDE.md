# ComfyUI Generation Server - Complete API Guide

## Server Details
- **URL**: `http://71.112.215.60:8188`
- **CORS**: Enabled for `discnxt.com`, `71.112.215.60`
- **GPUs**: 3x RTX 3090 (72GB VRAM total)

---

# API ENDPOINTS

## Core Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/prompt` | POST | Submit generation job |
| `/history/{prompt_id}` | GET | Get job status/outputs |
| `/view?filename=X&type=output` | GET | Download output file |
| `/upload/image` | POST | Upload image for I2V/I2I |
| `/system_stats` | GET | Server status |
| `/object_info` | GET | Available nodes |
| `/ws` | WebSocket | Real-time progress |

---

# 1. IMAGE GENERATION (NSFW/Photorealistic)

## Available Models

| Model | Best For | Notes |
|-------|----------|-------|
| `ponyRealism_V23ULTRA.safetensors` | NSFW, explicit | Uses booru tags |
| `juggernautXL_juggXIByRundiffusion.safetensors` | Photorealistic | General purpose |
| `RealVisXL_V5/RealVisXL_V5.0_fp16.safetensors` | Photorealistic | High quality |

## LoRAs
| LoRA | Effect |
|------|--------|
| `zy_AmateurStyle_v2.safetensors` | Amateur/candid look |
| `Realism Lora By Stable Yogi_V3_Lite.safetensors` | Enhanced realism |
| `Pony Realism Slider.safetensors` | Adjust realism level |

## Pony Prompt Format

Pony uses score-based quality tags + booru-style tags:

```
score_9, score_8_up, score_7_up, [quality tags], [subject], [action], [setting], [style]
```

### Quality Tags (REQUIRED for Pony)
- `score_9` - Highest quality
- `score_8_up` - High quality
- `score_7_up` - Good quality
- `score_6_up` - Acceptable
- `source_anime` or `source_realistic` - Style hint

### Subject Tags
```
1girl, 1boy, 2girls, 2boys, multiple_boys, multiple_girls
blonde_hair, brown_hair, red_hair, black_hair
blue_eyes, green_eyes, brown_eyes
large_breasts, medium_breasts, small_breasts
slim, curvy, athletic, muscular
```

### Explicit Tags (NSFW)
```
nude, naked, topless, bottomless
nipples, pussy, penis, anus
sex, vaginal, anal, oral
missionary, doggy_style, cowgirl, reverse_cowgirl
threesome, gangbang, dp (double_penetration)
cum, cumshot, creampie, facial
```

### Setting/Mood Tags
```
bedroom, bathroom, outdoors, pool, beach
romantic, passionate, rough, sensual
pov, from_above, from_below, from_side
soft_lighting, dramatic_lighting, natural_lighting
```

### Example NSFW Prompts

**Basic:**
```
score_9, score_8_up, source_realistic, 1girl, blonde_hair, blue_eyes, large_breasts, nude, lying_on_bed, bedroom, soft_lighting, photorealistic
```

**Explicit:**
```
score_9, score_8_up, source_realistic, 1girl, 2boys, blonde_hair, dp, double_penetration, threesome, nude, bedroom, passionate, detailed_skin
```

**Amateur Style:**
```
score_9, score_8_up, source_realistic, 1girl, brown_hair, selfie, nude, mirror, bathroom, amateur_photo, realistic_skin
```

### Negative Prompt (Always Use)
```
bad anatomy, bad hands, blurry, low quality, worst quality, deformed, mutated, extra limbs, disfigured, watermark, signature, text
```

## API Request - Image Generation

```javascript
const workflow = {
  "1": {
    "class_type": "CheckpointLoaderSimple",
    "inputs": {"ckpt_name": "ponyRealism_V23ULTRA.safetensors"}
  },
  "2": {
    "class_type": "CLIPTextEncode",
    "inputs": {
      "clip": ["1", 1],
      "text": "score_9, score_8_up, source_realistic, 1girl, blonde_hair, nude, bedroom, photorealistic"
    }
  },
  "3": {
    "class_type": "CLIPTextEncode",
    "inputs": {
      "clip": ["1", 1],
      "text": "bad anatomy, blurry, low quality, deformed"
    }
  },
  "4": {
    "class_type": "EmptyLatentImage",
    "inputs": {"width": 1024, "height": 1024, "batch_size": 1}
  },
  "5": {
    "class_type": "KSampler",
    "inputs": {
      "model": ["1", 0],
      "positive": ["2", 0],
      "negative": ["3", 0],
      "latent_image": ["4", 0],
      "seed": 12345,
      "steps": 30,
      "cfg": 7,
      "sampler_name": "euler",
      "scheduler": "normal",
      "denoise": 1
    }
  },
  "6": {
    "class_type": "VAEDecode",
    "inputs": {"samples": ["5", 0], "vae": ["1", 2]}
  },
  "7": {
    "class_type": "SaveImage",
    "inputs": {"images": ["6", 0], "filename_prefix": "output"}
  }
};

// Submit
const response = await fetch('http://71.112.215.60:8188/prompt', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({prompt: workflow})
});
const {prompt_id} = await response.json();
```

---

# 2. LOGO GENERATION (FLUX)

## Models
- `flux1-schnell.safetensors` (unet folder) - Fast, 4 steps
- `flux-klein/` - Apache licensed

## Required Files
- `clip/t5xxl_fp16.safetensors` - Text encoder
- `clip/clip_l.safetensors` - CLIP encoder
- `vae/ae.safetensors` - VAE decoder

## FLUX Prompt Format

FLUX uses natural language, not tags:

```
A [style] logo for [business], featuring [elements], [colors], [composition]
```

### Logo Prompt Examples

**Period Tracker App:**
```
minimalist logo for a period tracker app, pink and red gradient moon cycle icon, clean vector lines, white background, professional branding, centered composition
```

**Tech Startup:**
```
modern tech company logo, abstract geometric shapes, blue and purple gradient, sleek minimalist design, white background, vector art
```

**Restaurant:**
```
elegant restaurant logo, fork and knife forming a heart shape, gold and black color scheme, luxury branding, clean typography space
```

### FLUX Tips
- Be descriptive and specific
- Mention "white background" for clean logos
- Use "vector", "minimalist", "clean lines"
- Specify colors explicitly
- 4 steps is enough for Schnell

## API Request - Logo

```javascript
const workflow = {
  "1": {
    "class_type": "UNETLoader",
    "inputs": {"unet_name": "flux1-schnell.safetensors", "weight_dtype": "default"}
  },
  "2": {
    "class_type": "DualCLIPLoader",
    "inputs": {
      "clip_name1": "t5xxl_fp16.safetensors",
      "clip_name2": "clip_l.safetensors",
      "type": "flux"
    }
  },
  "3": {
    "class_type": "VAELoader",
    "inputs": {"vae_name": "ae.safetensors"}
  },
  "4": {
    "class_type": "CLIPTextEncode",
    "inputs": {
      "clip": ["2", 0],
      "text": "minimalist logo for period tracker app, pink moon cycle icon, clean vector, white background"
    }
  },
  "5": {
    "class_type": "EmptySD3LatentImage",
    "inputs": {"width": 1024, "height": 1024, "batch_size": 1}
  },
  "6": {
    "class_type": "KSampler",
    "inputs": {
      "model": ["1", 0],
      "positive": ["4", 0],
      "negative": ["4", 0],
      "latent_image": ["5", 0],
      "seed": 12345,
      "steps": 4,
      "cfg": 1,
      "sampler_name": "euler",
      "scheduler": "simple",
      "denoise": 1
    }
  },
  "7": {
    "class_type": "VAEDecode",
    "inputs": {"samples": ["6", 0], "vae": ["3", 0]}
  },
  "8": {
    "class_type": "SaveImage",
    "inputs": {"images": ["7", 0], "filename_prefix": "logo"}
  }
};
```

---

# 3. TEXT-TO-VIDEO (LTX)

## Models
| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| `LTX-Video/ltx-video-2b-v0.9.5.safetensors` | 6GB | Fast | Good |
| `LTX-Video/ltxv-13b-0.9.7-distilled-fp8.safetensors` | 15GB | Medium | Better |
| `LTX-2/ltx-2-19b-dev-fp8.safetensors` | 19GB | Slower | Best + Audio |

## Video Prompt Format

```
[Subject description], [action/motion], [setting], [camera], [style], [quality tags]
```

### Motion Keywords
```
walking, running, dancing, jumping
turning head, waving, smiling
slow motion, timelapse
camera pan, zoom in, tracking shot
```

### Video Prompt Examples

**Woman Walking:**
```
beautiful woman in red bikini walking confidently on beach, ocean waves, sunny day, men watching admiringly, smooth motion, cinematic, 4K, golden hour lighting
```

**Action Scene:**
```
woman in leather jacket, stepping on defeated opponents, victory pose, dramatic lighting, slow motion, action movie style, detailed textures
```

**Romantic:**
```
couple embracing, soft kiss, bedroom setting, warm lighting, intimate atmosphere, slow gentle motion, cinematic depth of field
```

### Video Settings
- **Width/Height**: 512x512 or 768x512 (16:9)
- **Length**: 41 frames = ~1.7 seconds at 24fps
- **Steps**: 20-30
- **CFG**: 2.5-4

## API Request - Video

```javascript
// Note: LTX uses different loader nodes
const workflow = {
  "1": {
    "class_type": "LTXVLoader",
    "inputs": {
      "ckpt_name": "ltx-video-2b-v0.9.5.safetensors",
      "dtype": "bfloat16"
    }
  },
  "2": {
    "class_type": "CLIPLoader",
    "inputs": {
      "clip_name": "t5xxl_fp16.safetensors",
      "type": "ltxv"
    }
  },
  "3": {
    "class_type": "CLIPTextEncode",
    "inputs": {
      "clip": ["2", 0],
      "text": "woman in bikini on beach, walking confidently, sunny day, cinematic, 4K"
    }
  },
  "4": {
    "class_type": "EmptyLTXVLatentVideo",
    "inputs": {"width": 512, "height": 512, "length": 41, "batch_size": 1}
  },
  "5": {
    "class_type": "LTXVScheduler",
    "inputs": {
      "latent": ["4", 0],
      "steps": 20,
      "max_shift": 2.05,
      "base_shift": 0.95,
      "stretch": true,
      "terminal": 0.1
    }
  },
  "6": {
    "class_type": "KSamplerSelect",
    "inputs": {"sampler_name": "euler"}
  },
  "7": {
    "class_type": "SamplerCustom",
    "inputs": {
      "model": ["1", 0],
      "positive": ["3", 0],
      "negative": ["3", 0],
      "sampler": ["6", 0],
      "sigmas": ["5", 0],
      "latent_image": ["4", 0],
      "add_noise": true,
      "noise_seed": 12345,
      "cfg": 3
    }
  },
  "8": {
    "class_type": "VAEDecode",
    "inputs": {"samples": ["7", 0], "vae": ["1", 1]}
  },
  "9": {
    "class_type": "VHS_VideoCombine",
    "inputs": {
      "images": ["8", 0],
      "frame_rate": 24,
      "filename_prefix": "video",
      "format": "video/h264-mp4"
    }
  }
};
```

---

# 4. IMAGE-TO-VIDEO (CogVideoX)

Upload image first, then generate video from it.

## Upload Image

```javascript
async function uploadImage(file) {
  const form = new FormData();
  form.append('image', file);
  form.append('subfolder', 'input');
  form.append('type', 'input');

  const res = await fetch('http://71.112.215.60:8188/upload/image', {
    method: 'POST',
    body: form
  });
  return res.json(); // {name: "filename.png", subfolder: "input", type: "input"}
}
```

## I2V Workflow

```javascript
const workflow = {
  "1": {
    "class_type": "CogVideoXModelLoader",
    "inputs": {"model_name": "CogVideoX-5b", "precision": "fp16", "enable_vae_slicing": "enabled"}
  },
  "2": {
    "class_type": "LoadImage",
    "inputs": {"image": "uploaded_filename.png"}  // From upload response
  },
  "3": {
    "class_type": "CogVideoTextEncode",
    "inputs": {
      "model": ["1", 0],
      "text": "the person slowly turns their head and smiles, smooth motion, cinematic"
    }
  },
  "4": {
    "class_type": "CogVideoImageEncode",
    "inputs": {"image": ["2", 0]}
  },
  "5": {
    "class_type": "CogVideoSampler",
    "inputs": {
      "model": ["1", 0],
      "conditioning": ["3", 0],
      "latent": ["4", 0],
      "seed": 12345,
      "steps": 50,
      "cfg": 6,
      "num_frames": 49,
      "width": 720,
      "height": 480
    }
  },
  "6": {
    "class_type": "CogVideoDecode",
    "inputs": {"model": ["1", 0], "latent": ["5", 0]}
  },
  "7": {
    "class_type": "VHS_VideoCombine",
    "inputs": {
      "images": ["6", 0],
      "frame_rate": 8,
      "filename_prefix": "i2v_output",
      "format": "video/h264-mp4"
    }
  }
};
```

---

# MONITORING & DOWNLOADING

## Check Job Status

```javascript
async function checkStatus(promptId) {
  const res = await fetch(`http://71.112.215.60:8188/history/${promptId}`);
  const data = await res.json();

  const job = data[promptId];
  if (!job) return {status: 'not_found'};

  return {
    status: job.status?.status_str || 'running',
    completed: job.status?.completed || false,
    outputs: job.outputs || null
  };
}
```

## WebSocket Progress (Real-time)

```javascript
function watchProgress(promptId, onProgress, onComplete) {
  const ws = new WebSocket('ws://71.112.215.60:8188/ws');

  ws.onmessage = (event) => {
    const msg = JSON.parse(event.data);

    switch(msg.type) {
      case 'progress':
        // msg.data = {value: 5, max: 30, prompt_id: "...", node: "..."}
        onProgress(msg.data.value, msg.data.max);
        break;

      case 'executing':
        // msg.data.node = null means complete
        if (msg.data.node === null && msg.data.prompt_id === promptId) {
          onComplete();
          ws.close();
        }
        break;

      case 'executed':
        // Node finished, outputs available
        console.log('Node output:', msg.data.output);
        break;

      case 'execution_error':
        console.error('Error:', msg.data);
        ws.close();
        break;
    }
  };

  return ws;
}
```

## Download Output

```javascript
async function downloadOutput(promptId) {
  const res = await fetch(`http://71.112.215.60:8188/history/${promptId}`);
  const data = await res.json();

  const outputs = data[promptId]?.outputs;
  if (!outputs) return null;

  const files = [];
  for (const nodeId in outputs) {
    const nodeOutput = outputs[nodeId];

    // Images
    if (nodeOutput.images) {
      for (const img of nodeOutput.images) {
        files.push({
          type: 'image',
          url: `http://71.112.215.60:8188/view?filename=${img.filename}&type=${img.type}&subfolder=${img.subfolder || ''}`
        });
      }
    }

    // Videos (VHS_VideoCombine)
    if (nodeOutput.gifs) {
      for (const vid of nodeOutput.gifs) {
        files.push({
          type: 'video',
          url: `http://71.112.215.60:8188/view?filename=${vid.filename}&type=${vid.type}&subfolder=${vid.subfolder || ''}`
        });
      }
    }
  }

  return files;
}
```

---

# COMPLETE CLIENT CLASS

```javascript
class ComfyClient {
  constructor(baseUrl = 'http://71.112.215.60:8188') {
    this.baseUrl = baseUrl;
  }

  // Upload image for I2V or I2I
  async uploadImage(file) {
    const form = new FormData();
    form.append('image', file);
    form.append('subfolder', 'input');
    form.append('type', 'input');

    const res = await fetch(`${this.baseUrl}/upload/image`, {
      method: 'POST',
      body: form
    });
    return res.json();
  }

  // Submit workflow
  async submit(workflow, clientId = null) {
    const body = {prompt: workflow};
    if (clientId) body.client_id = clientId;

    const res = await fetch(`${this.baseUrl}/prompt`, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(body)
    });
    return res.json();
  }

  // Get job history
  async getHistory(promptId) {
    const res = await fetch(`${this.baseUrl}/history/${promptId}`);
    return res.json();
  }

  // Poll until complete
  async waitForCompletion(promptId, pollInterval = 1000) {
    while (true) {
      const history = await this.getHistory(promptId);
      const job = history[promptId];

      if (job?.status?.completed) {
        return job;
      }

      if (job?.status?.status_str === 'error') {
        throw new Error(JSON.stringify(job.status.messages));
      }

      await new Promise(r => setTimeout(r, pollInterval));
    }
  }

  // Watch with WebSocket
  watchProgress(promptId, callbacks = {}) {
    const ws = new WebSocket(`ws://${new URL(this.baseUrl).host}/ws`);

    ws.onmessage = (e) => {
      const msg = JSON.parse(e.data);

      if (msg.type === 'progress' && callbacks.onProgress) {
        callbacks.onProgress(msg.data.value, msg.data.max);
      }

      if (msg.type === 'executing' && msg.data.node === null) {
        if (callbacks.onComplete) callbacks.onComplete();
        ws.close();
      }

      if (msg.type === 'execution_error' && callbacks.onError) {
        callbacks.onError(msg.data);
        ws.close();
      }
    };

    return ws;
  }

  // Get output files from completed job
  async getOutputFiles(promptId) {
    const history = await this.getHistory(promptId);
    const outputs = history[promptId]?.outputs;
    if (!outputs) return [];

    const files = [];
    for (const nodeId in outputs) {
      const out = outputs[nodeId];

      if (out.images) {
        for (const img of out.images) {
          files.push({
            type: 'image',
            filename: img.filename,
            url: `${this.baseUrl}/view?filename=${encodeURIComponent(img.filename)}&type=${img.type}`
          });
        }
      }

      if (out.gifs) {
        for (const vid of out.gifs) {
          files.push({
            type: 'video',
            filename: vid.filename,
            url: `${this.baseUrl}/view?filename=${encodeURIComponent(vid.filename)}&type=${vid.type}`
          });
        }
      }
    }

    return files;
  }

  // Download file as blob
  async downloadFile(url) {
    const res = await fetch(url);
    return res.blob();
  }
}

// Usage Example
async function generateNSFWImage() {
  const client = new ComfyClient();

  const workflow = {
    "1": {"class_type": "CheckpointLoaderSimple", "inputs": {"ckpt_name": "ponyRealism_V23ULTRA.safetensors"}},
    "2": {"class_type": "CLIPTextEncode", "inputs": {"clip": ["1", 1], "text": "score_9, score_8_up, 1girl, blonde_hair, nude, bedroom, photorealistic"}},
    "3": {"class_type": "CLIPTextEncode", "inputs": {"clip": ["1", 1], "text": "bad anatomy, blurry"}},
    "4": {"class_type": "EmptyLatentImage", "inputs": {"width": 1024, "height": 1024, "batch_size": 1}},
    "5": {"class_type": "KSampler", "inputs": {"model": ["1", 0], "positive": ["2", 0], "negative": ["3", 0], "latent_image": ["4", 0], "seed": Math.floor(Math.random() * 1000000), "steps": 30, "cfg": 7, "sampler_name": "euler", "scheduler": "normal", "denoise": 1}},
    "6": {"class_type": "VAEDecode", "inputs": {"samples": ["5", 0], "vae": ["1", 2]}},
    "7": {"class_type": "SaveImage", "inputs": {"images": ["6", 0], "filename_prefix": "nsfw"}}
  };

  // Submit
  const {prompt_id} = await client.submit(workflow);
  console.log('Submitted:', prompt_id);

  // Watch progress
  client.watchProgress(prompt_id, {
    onProgress: (current, total) => console.log(`Progress: ${current}/${total}`),
    onComplete: async () => {
      const files = await client.getOutputFiles(prompt_id);
      console.log('Done! Files:', files);
    }
  });
}
```

---

# MULTI-GPU SETUP

For larger models, use MultiGPU loader nodes:

```javascript
// Instead of CheckpointLoaderSimple, use:
{
  "class_type": "CheckpointLoaderSimpleDisTorch2MultiGPU",
  "inputs": {
    "ckpt_name": "ponyRealism_V23ULTRA.safetensors",
    "compute_device": "cuda:0",      // Main GPU for sampling
    "virtual_vram_gb": 5,            // Offload this much
    "offload_device": "cuda:1",      // Secondary GPU
    "expert_mode_allocation": "",
    "force_reload": true
  }
}

// For CLIP on different GPU:
{
  "class_type": "CLIPLoaderMultiGPU",
  "inputs": {
    "clip_name": "t5xxl_fp16.safetensors",
    "type": "ltxv",
    "device": "cuda:2"
  }
}
```

---

# SERVICE MANAGEMENT

```bash
# Start/Stop/Restart
sudo systemctl start comfyui
sudo systemctl stop comfyui
sudo systemctl restart comfyui

# Check status
sudo systemctl status comfyui

# View logs
journalctl -u comfyui -f

# Check GPU usage
nvidia-smi -l 1
```

---

# TROUBLESHOOTING

## Common Errors

**"ckpt_name not in list"**
- Model not in correct folder
- Restart ComfyUI to rescan models

**"Out of memory"**
- Use MultiGPU nodes to offload
- Reduce resolution/batch size
- Use fp8/fp16 quantized models

**"Node does not exist"**
- Custom node not installed
- Restart ComfyUI after installing

## Model Locations

```
models/
├── checkpoints/     # SDXL, Pony checkpoints
├── unet/           # FLUX unet
├── clip/           # Text encoders (t5xxl, clip_l)
├── vae/            # VAE decoders (ae.safetensors)
├── loras/          # LoRA models
├── LTX-Video/      # LTX video models
├── LTX-2/          # LTX-2 audio+video
├── CogVideo/       # CogVideoX models
├── Mochi/          # Mochi video models
└── flux-klein/     # FLUX Klein (logos)
```

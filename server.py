import runpod
from audiocraft.models import MusicGen
from audiocraft.data.audio import audio_write
import torch
import os
import uuid

# Load MusicGen model once on pod start
print("Loading MusicGen model...")
model = MusicGen.get_pretrained('facebook/musicgen-medium')
model.set_generation_params(duration=10)  # adjust duration

OUTPUT_DIR = "/workspace/outputs"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def handler(job):
    try:
        job_input = job["input"]
        prompt = job_input.get("prompt", "a cinematic orchestral score")
        duration = job_input.get("duration", 10)

        model.set_generation_params(duration=duration)

        print(f"Generating for prompt: {prompt}")
        output = model.generate([prompt])

        filename = f"{uuid.uuid4()}.wav"
        filepath = os.path.join(OUTPUT_DIR, filename)

        audio_write(filepath, output[0].cpu(), model.sample_rate, strategy="loudness")

        return {"status": "success", "file": filepath}

    except Exception as e:
        return {"status": "error", "message": str(e)}

# Start RunPod serverless
runpod.serverless.start({"handler": handler})

#!/usr/bin/env python3
"""Generate placeholder WAV sound effects for QSabotage."""
import wave
import struct
import math
import os
import random

SAMPLE_RATE = 44100

def write_wav(filename, samples, sample_rate=SAMPLE_RATE):
    """Write 16-bit mono WAV file from float samples (-1.0 to 1.0)."""
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with wave.open(filename, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sample_rate)
        for s in samples:
            clamped = max(-1.0, min(1.0, s))
            w.writeframes(struct.pack('<h', int(clamped * 32767)))

def generate_fire():
    """Short high-frequency zap (~50ms)."""
    duration = 0.05
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env = 1.0 - (i / n)
        freq = 1800 - (i / n) * 1200
        samples.append(env * math.sin(2 * math.pi * freq * t) * 0.8)
    return samples

def generate_explosion():
    """White noise burst with decay (~200ms)."""
    duration = 0.2
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        env = 1.0 - (i / n)
        noise = random.uniform(-1.0, 1.0)
        t = i / SAMPLE_RATE
        rumble = math.sin(2 * math.pi * 80 * t) * 0.5
        samples.append(env * (noise * 0.6 + rumble * 0.4) * 0.9)
    return samples

def generate_heli_hum():
    """Buzzy drone loop (~500ms, seamless loop)."""
    duration = 0.5
    n = int(SAMPLE_RATE * duration)
    samples = []
    base_freq = 90
    for i in range(n):
        t = i / SAMPLE_RATE
        # Sawtooth-like buzz via stacked odd+even harmonics
        s = 0.0
        for h in range(1, 10):
            s += math.sin(2 * math.pi * base_freq * h * t) / h
        s *= 0.35
        # Mild chop for rotor feel
        chop = 0.7 + 0.3 * math.sin(2 * math.pi * 18 * t)
        samples.append(s * chop)
    return samples

def generate_splat():
    """Quick noise thud (~100ms)."""
    duration = 0.1
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        env = 1.0 - (i / n) ** 0.5
        t = i / SAMPLE_RATE
        noise = random.uniform(-1.0, 1.0)
        thud = math.sin(2 * math.pi * 120 * t)
        samples.append(env * (noise * 0.4 + thud * 0.6) * 0.7)
    return samples

if __name__ == '__main__':
    random.seed(42)
    write_wav('sounds/fire.wav', generate_fire())
    write_wav('sounds/explosion.wav', generate_explosion())
    write_wav('sounds/heli_hum.wav', generate_heli_hum())
    write_wav('sounds/splat.wav', generate_splat())
    print("Generated sound files in sounds/")

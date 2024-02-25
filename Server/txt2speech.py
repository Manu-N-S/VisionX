from gtts import gTTS
import pygame
from io import BytesIO

text = "Heehehehheheheheh"
tts = gTTS(text)
audio_stream = BytesIO()

tts.write_to_fp(audio_stream)

audio_stream.seek(0)

pygame.mixer.init()
pygame.mixer.music.load(audio_stream)
pygame.mixer.music.play()
while pygame.mixer.music.get_busy():
    continue

import threading
import queue
import time
import math
from gtts import gTTS
import pygame
from io import BytesIO

# Define a function to be executed by the thread asking for input
def input_thread_function():
    while True:
        try:
            user_input = input("Enter text (type 'exit' to quit): ")
            if user_input.lower() == 'exit':
                input_queue.put(user_input.lower())  # Put None into the queue to signal termination
                break
            text = user_input
            input_queue.put(text)  # Put the input into the shared queue
        except ValueError:
            print("Please enter a valid integer or 'exit' to quit.")

# Define a function to be executed by the thread calculating factorial
def factorial_thread_function():
    while True:
        try:
            text = input_queue.get() 
            if text == 'exit':
                break # Get the number from the shared queue
            tts = gTTS(text)
            audio_stream = BytesIO()

            tts.write_to_fp(audio_stream)

            audio_stream.seek(0)

            pygame.mixer.init()
            pygame.mixer.music.load(audio_stream)
            pygame.mixer.music.play()
            while pygame.mixer.music.get_busy():
                continue
        except queue.Empty:
            pass  # Continue if the queue is empty
        except Exception as e:
            print(f"An error occurred: {e}")

if __name__ == "__main__":
    input_queue = queue.Queue()  # Shared queue to pass input between threads
    # Create the input thread
    input_thread = threading.Thread(target=input_thread_function)
    # Create the factorial thread
    factorial_thread = threading.Thread(target=factorial_thread_function)

    # Start both threads
    input_thread.start()
    factorial_thread.start()

    try:
        # Wait for the input thread to finish (which it will when 'exit' is input)
        input_thread.join()
        # Wait for the factorial thread to finish
        factorial_thread.join()
    except KeyboardInterrupt:
        print("\nExiting program due to KeyboardInterrupt.")

    print("Program exited.")

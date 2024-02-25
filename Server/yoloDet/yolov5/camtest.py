import cv2

def main():
    # Open the default camera (usually the first camera available)
    cap = cv2.VideoCapture(0)

    # Check if the camera opened successfully
    if not cap.isOpened():
        print("Error: Could not open camera.")
        return

    # Get the resolution of the camera
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    print("Resolution: {} x {}".format(width, height))

    # Release the camera
    cap.release()

if __name__ == "__main__":
    main()

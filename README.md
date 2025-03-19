# RTSP stream to Prusa Connect

This is a simple script that will take an snapshot at a regular interval from an RTSP stream and upload it to the [Prusa Connect](https://connect.prusa3d.com/) [Camera API](https://connect.prusa3d.com/docs/cameras/).

I am personally using this to use a [Reolink E1 Zoom camera](https://reolink.com/product/e1-zoom/) with Prusa Connect.

## Requirements

- A copy of this repository
- Docker Desktop (or Docker Community Edition and Docker Compose on Linux)
- A camera that supports RTSP streaming
- A Prusa Connect account

## Usage

To paraphrase [the more extensive directions upstream directions](https://www.reddit.com/r/prusa3d/comments/1971673/streaming_a_webcam_via_rtsp_to_prusa_connect/) Prusa printer that run PrusaLink internally, like the MK4+, can be setup very easily. For older printers see the linked discussion.

1) Enable the RTSP stream on your camera. It is also possible to get an RTSP from some cameras that don't natively support it, but I won't be covering that here. The detailed link above may touch on this more.
2) Next, you will need to obtain a `Fingerprint` and `Token` (_think username and password_) for a new camera that is registered with Prusa Connect. You can create this camera using your laptop camera and then take it over with the RTSP stream snapshots from `ffmpeg` (_step 3_). To get these 2 values you'll need to use the **Developer Tools** of whichever web browser you use. While in Prusa Connect with your printer selected, go to Camera, select Add new web camera, and click the QR code (_which will open up a new window_). You may need to take a picture of the QR code and hold it in-front of your camera to finished the camera registration process. Before the next step, open up Developer Tools within your web browser. (If you are uncertain how, [this page shows steps for various browsers](https://balsamiq.com/support/faqs/browserconsole/).) Once Developer Tools is open, select the **Network** tab, and then in Prusa Connect select **Start Camera**. In the Developer Tool's Network tab you'll start seeing `snapshot` entries. Select one and scroll to the bottom of `Request Headers`. You're looking for two values, `Fingerprint` (_ID for your specific account_) and Token (_which is the secret for the new camera_). You should close the Prusa Connect windows once you have those two values saved.
3) In this directory copy `env-example.txt` to `.env` and replace the `REDACTED` values with your camera's RTSP URL, the fingerprint, and token from the previous step.
4) Lastly, you'll be creating a Docker container that runs `ffmpeg`. It is possible to do this without Docker or Linux containers, but this makes it all a little easier for those less interested in the more technical aspects of the process. To run the container, ensure that `Docker` is running and then execute the command `docker-compose up -d` in this directory.
5) If you check Prusa Connect now, you should see a current snapshot from your camera.

## Troubleshooting

- You can use [VLC](https://www.videolan.org/vlc/) to ensure that you have the correct RTSP URL.
- Additional details can be found in the [upstream discussion](https://www.reddit.com/r/prusa3d/comments/1971673/streaming_a_webcam_via_rtsp_to_prusa_connect/)

---

This was initially blatantly borrowed from here:

- [streaming_a_webcam_via_rtsp_to_prusa_connect](https://www.reddit.com/r/prusa3d/comments/1971673/streaming_a_webcam_via_rtsp_to_prusa_connect/)
- [https://github.com/cdgriffith/pi_streaming_setup/tree/master](cdgriffith/pi_streaming_setup)


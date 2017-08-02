# vid-ee-oh

Try it [here](testvid.html).

## Real time, in browser, video mixing

vid-ee-oh is a demonstration of the HTML5 video API.  It takes video from your webcam, and swaps out the background of your room for another scene.  It's effectively a greenscreen, but you don't need the greenscreen.

### Features

vid-ee-oh shows off several features, by copying images from the video feed, applying a temporal blur to smooth out noise from  the camera, then switching the background of the image.

This is all done using the HTML 5 video API, without plugins or downloads.

### Video API

vid-ee-oh uses the HTML5 video API, a standard that changes constantly as the committee chases the latest fads in Javscript programming.

The most recent fad is promises, which are vastly superior to calling functions, for reasons that are obvious to Javscript programmers, and nobody else.

Fire up your text editors and replace 
```javascript
navigator.webkitGetUserMedia({video: true}, function(stream) {
```
with

```javascript
navigator.mediaDevices.getUserMedia({video: true}).then(function(stream) {
```

which is vastly superior, possibly because Javscript programmers are paid by character.

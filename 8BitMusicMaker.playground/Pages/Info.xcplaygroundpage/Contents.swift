/*:
![title](8BitMusicMakerWhiteAndPinkBig.png)
[👉 Demo](@next)

# About:
Feel nostalgic when you hear an old video game's music? If so, 8-Bit Music Maker is here to let you re-live those memories! It's packed with 8-Bit sounds from the past, and filled with endless possibilities of songs (some creativity required)! This playground is the perfect place to be creative, and bring out your inner child.

### Inspiration:
_While I wasn't born in the 80's, I spent a lot of my childhood playing older generation video games which were handed down to me. Some of these games have brought me joy to this day!_

### Resources:
The resources found in this playground were all created by me. I developed the C note samples in [Garage Band.app](https://www.apple.com/ca/mac/garageband/) using an [8-Bit plugin](http://www.ymck.net/en/download/magical8bitplug/). I drew all the pixel art in [Pixen.app](http://itunes.apple.com/us/app/pixen/id525180431?mt=12) which is available on the Mac App Store.

### Author:
[Ben Emdon 👨‍💻](https://github.com/BenEmdon)

# Features:
## Live Sequencing 🎼:
Utilizing the powerful `AVAudioEngine`, the 8-Bit Music Maker supports live note sequencing! This means as the Bit Music maker is sequencing you can toggle notes on and off in real time!

![Live Sequencing](LiveSequencing.gif)
## Instruments 🎹:
8-Bit Music Maker supports 3 different "wave forms", or "instruments", as I like to refer to them. While these are not the only wave forms supported in 8-bit architectures, they were certainly the most popular in 80's video games. Take a look at the `Instrument` type!

`⌥ + click` it!
*/
let instrumentEnum: Instrument

/*:
Go ahead and inspect each of the following images if you'd like an idea what each wave form looks like:
*/
import UIKit
let squareWave = UIImage(instrumentForWave: .square)
let triangleWave = UIImage(instrumentForWave: .triangle)
let noiseWave = UIImage(instrumentForWave: .noise)
/*:
## Configuration ⚙️:
You can configure `BitMusicMaker` with the following configurations:
* beats per minute (BPM)
* length of sequence in blocks
* number of octaves
## Recording 🎤:
8-Bit Music maker also allows you to record the music you make and save it to disk!
To record, hit the record button and make sure you press play on the sequencer:

![Recording](Recording.gif)
## NOTES ABOUT RECORDING ⚠️
In order to save your 8-Bit Music, you must ensure the following directory exists:

`/Users/{YOUR USER NAME}/Documents/Shared\ Playground\ Data`

---
[👉 Demo](@next)
*/

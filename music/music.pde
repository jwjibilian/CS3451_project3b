import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;
 
void setup()
{
  size(512, 600);
 
  // always start Minim first!
  minim = new Minim(this);
 
  // specify 512 for the length of the sample buffers. the default buffer size is 1024
// *** YOU MUST HAVE A FILE mySong.mp3 IN THE SKETCH FLDER
  //  song = minim.loadFile("mySong.wav", 512);
   song = minim.loadFile("mySong.mp3", 1024);
  song.play();
 
  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  fft = new FFT(song.bufferSize(), song.sampleRate());
}
 
void draw()
{
  background(255);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  fft.forward(song.mix);
 
  stroke(0, 255, 250);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  int s=10;
  strokeWeight(s);
  for(int i = 0; i < fft.specSize(); i++) line(i*s, height, i*s, height - fft.getBand(i)*60);

   strokeWeight(2);

  stroke(255,0,0);
  // I draw the waveform by connecting 
  // neighbor values with a line. I multiply 
  // each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
  for(int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*500);
    line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*500);
  }
}
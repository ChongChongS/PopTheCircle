class Audio {
  AudioPlayer song;
  BeatDetect beat;
  BeatListener bl;
  FFT fft;

  Audio() {
    song = minim.loadFile("bgm.mp3", 1024);

    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(300);  

    bl = new BeatListener(beat, song);

    fft = new FFT( song.bufferSize(), song.sampleRate() );
  }

  boolean canCreat() {
    if (beat.isKick()){//&& frameRate%4 <= 0.2){//beat.isKick() && beat.isHat()) || beat.isSnare()
      return true;
    } else {
      return false;
    }
  }

  void display() {
    stroke(255);
    fft.forward(song.mix);
    for (int i = 0; i < fft.specSize(); i++)
    {
      line( i, height, i, height - fft.getBand(i)*8 );
    }
  }
}
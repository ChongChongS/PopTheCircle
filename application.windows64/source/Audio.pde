class Audio {
  AudioPlayer song;
  BeatDetect beat;
  BeatListener bl;
  FFT fft;

  Audio() {
    song = minim.loadFile("bgm.mp3", 2048);

    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(300);  

    bl = new BeatListener(beat, song);

    fft = new FFT( song.bufferSize(), song.sampleRate() );
  }

  boolean canCreat(int id) {
    switch(id) {
      case 1:
        if(beat.isKick() && beat.isSnare())
          return true;
        else
          return false;
      case 2:
        if(beat.isKick())
          return true;
        else
          return false;
      case 3:
        if(beat.isKick() || beat.isSnare())
          return true;
        else
          return false;
      case 4:
        if(beat.isKick() || beat.isHat())
          return true;
        else
          return false;
      default:
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
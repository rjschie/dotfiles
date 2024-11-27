function sound -d "Controls the sound outputs/inputs"
  if not command -q SwitchAudioSource
    printn "%sThat command doesn't exist.%s\nTo install switchaudio-osx: %sbrew install switchaudio-osx%s" \
      (set_color yellow) (set_color normal) \
      (set_color green) (set_color normal)
    return
  end

  set -l IN_MIC "MacBook Pro Microphone"
  set -l OUT_SPEAKERS "MacBook Pro Speakers"
  set -l OUT_HEADPHONES "New Headphones"
  set -l AIRPODS "New Headphones"

  set -l HEADPHONE_VOLUME 30
  set -l SPEAKER_VOLUME 60
  set -l CALL_INPUT_VOLUME 60

  switch $argv[1]
    case -h
      echo "sound mute | calls | speakers | headphones"
    case m mute
      SwitchAudioSource -t input -s $IN_MIC
      SwitchAudioSource -t output -s $OUT_SPEAKERS
      osascript -e "set volume input volume 0"
      osascript -e "set volume output volume 0"
    case ac acall acalls
      SwitchAudioSource -t input -s $AIRPODS
      SwitchAudioSource -t output -s $AIRPODS
      osascript -e "set volume input volume $CALL_INPUT_VOLUME"
      osascript -e "set volume output volume $SPEAKER_VOLUME"
    case c call calls
      SwitchAudioSource -t input -s $IN_MIC
      SwitchAudioSource -t output -s $OUT_SPEAKERS
      osascript -e "set volume input volume $CALL_INPUT_VOLUME"
      osascript -e "set volume output volume $SPEAKER_VOLUME"
    case hc headphonecall
      SwitchAudioSource -t input -s $IN_MIC
      SwitchAudioSource -t output -s $OUT_HEADPHONES
      osascript -e "set volume input volume $CALL_INPUT_VOLUME"
      osascript -e "set volume output volume $HEADPHONE_VOLUME"
    case s speaker speakers
      SwitchAudioSource -t input -s $IN_MIC
      SwitchAudioSource -t output -s $OUT_SPEAKERS
      osascript -e "set volume input volume 0"
      osascript -e "set volume output volume $HEADPHONE_VOLUME"
    case h headphone headphones
      SwitchAudioSource -t input -s $IN_MIC
      SwitchAudioSource -t output -s $OUT_HEADPHONES
      osascript -e "set volume input volume 0"
      osascript -e "set volume output volume $HEADPHONE_VOLUME"
    case '*' r reset
      SwitchAudioSource -t input -s $IN_MIC
      SwitchAudioSource -t output -s $OUT_SPEAKERS
      osascript -e "set volume input volume 0"
      osascript -e "set volume output volume 0"

      if SwitchAudioSource -a -t output | grep -q $OUT_HEADPHONES
        SwitchAudioSource -t input -s $IN_MIC
        SwitchAudioSource -t output -s $OUT_HEADPHONES
        osascript -e "set volume input volume 0"
        osascript -e "set volume output volume $HEADPHONE_VOLUME"
      end
  end
end

function convert-to-heic -d "Convert a PNG to HEIC"
  set -l output_name (basename $argv[1] .png).heic
  echo $output_name
  heif-enc $argv[1] -L -b 12 -o $output_name
  exiftool -overwrite_original -tagsFromFile $argv[1] -all:all $output_name
end

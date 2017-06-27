function gzipsize
  gzip $argv[1]
  du -h $argv[1].gz
  rm $argv[1].gz
end


require 'zlib'
require 'zopfli'

def gzip_compress(source, source_file_name)
  output_file_name = "#{source_file_name}.gzip.gz"
  File.open(output_file_name, "w") do |f|
    gz = Zlib::GzipWriter.new(f, Zlib::BEST_COMPRESSION)
    gz.write(source)
    gz.close
  end
  output_file_name
end

# If omitted, Zopfli itself defaults to 15 iterations
def zopfli_compress(source, source_file_name, iterations=nil)
  output_file_name = "#{source_file_name}.zopf.gz"
  IO.binwrite(
    output_file_name,
    Zopfli.deflate(source, format: :gzip, num_iterations: iterations)
  )
  output_file_name
end

def assert_decompresses(compressed_file, expected_uncompressed_data)
  uncompressed_data = Zlib::GzipReader.new(compressed_file).read
  if uncompressed_data != expected_uncompressed_data
    raise "#{compressed_file.path} did not decompress to expected data"
  end
end

def compare_file_size(file1, file2)
  percentage = file1.size/file2.size.to_f * 100
  "#{percentage.round(2)}% of #{file2.path}"
end

puts "-"*70
['codetriage.js', 'codetriage.css', 'codetriage.svg'].each do |source_file_name|

  puts "                    File: #{source_file_name}"
  source = File.read(source_file_name)

  gzipped_file_name = gzip_compress(source, source_file_name)
  gzipped_file = File.new(gzipped_file_name)
  assert_decompresses(gzipped_file, source)

  puts "                 Gzipped: #{gzipped_file.size} bytes"

  # 15 iterations is the preset default for Zopfli
  [1, 15, 15*15].each do |iterations|
    zopflied_file_name = zopfli_compress(source, source_file_name, iterations)
    zopflied_file = File.new(zopflied_file_name)
    assert_decompresses(zopflied_file, source)
    puts "Zopflied (#{iterations} iterations): #{zopflied_file.size} bytes (#{compare_file_size(zopflied_file, gzipped_file)})"
  end

  puts "-"*70
end

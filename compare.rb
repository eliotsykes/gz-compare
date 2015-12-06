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

# DEFAULT_ZOPFLI_ITERATIONS = 15 # If omitted, Zopfli itself defaults to 15 iterations
def zopfli_compress(source, source_file_name, num_iterations=nil)
  output_file_name = "#{source_file_name}.zopf.gz"
  IO.binwrite(
    output_file_name,
    Zopfli.deflate(source, format: :gzip, num_iterations: num_iterations)
  )
  output_file_name
end

def assert_decompresses(compressed_file, expected_uncompressed_data)
  uncompressed_data = Zlib::GzipReader.new(compressed_file).read
  if uncompressed_data != expected_uncompressed_data
    raise "#{compressed_file.path} did not decompress to expected data"
  end
end

# asset_url = 'https://issuetriage-herokuapp-com.global.ssl.fastly.net/assets/application-c4dfdc831b963c426131ae50f1facfbe6de899ad7f860fb7758b0706ab230e7a.js'


source_file_name = 'issuetriage.js'
source = File.read(source_file_name)

gzipped_file_name = gzip_compress(source, source_file_name)
zopflied_file_name = zopfli_compress(source, source_file_name)

gzipped_file = File.new(gzipped_file_name)
zopflied_file = File.new(zopflied_file_name)

assert_decompresses(gzipped_file, source)
assert_decompresses(zopflied_file, source)

def compare_file_size(file1, file2)
  percentage = file1.size/file2.size.to_f * 100
  "#{percentage.round(1)}% of #{file2.path}"
end

# puts "Original file size: #{File.size(source_file_name)}"
puts " Gzipped file size: #{gzipped_file.size}"
puts "Zopflied file size: #{zopflied_file.size} (#{compare_file_size(zopflied_file, gzipped_file)})"


# TODO:
# - compare file sizes for JS, CSS, SVG examples
# - estimate transfer time saving over various network speeds

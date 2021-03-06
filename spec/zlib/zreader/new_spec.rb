# encoding: UTF-8

require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'
require 'archive/support/zlib'
require 'archive/support/binary_stringio'

describe "Zlib::ZReader.new" do
  it "returns a new instance" do
    Zlib::ZReader.new(BinaryStringIO.new).class.should == Zlib::ZReader
  end

  it "does not require window_bits to be set" do
    data = ZlibSpecs.test_data
    compressed_data = BinaryStringIO.new
    Zlib::ZWriter.open(compressed_data) do |zw|
      zw.write(data)
    end
    compressed_data.rewind

    zr = Zlib::ZReader.new(compressed_data)
    zr.read.should == data
    zr.close
  end

  it "allows window_bits to be set" do
    data = ZlibSpecs.test_data
    compressed_data = BinaryStringIO.new
    window_bits = -Zlib::MAX_WBITS
    Zlib::ZWriter.open(
      compressed_data, Zlib::DEFAULT_COMPRESSION, window_bits
    ) do |zw|
      zw.write(data)
    end
    compressed_data.rewind

    zr = Zlib::ZReader.new(compressed_data, window_bits)
    zr.read.should == data
    zr.close
  end
end

#!/usr/bin/env ruby
require 'fiddle'
require 'fiddle/import'

module PulseAudio
  module SampleFormat
    INVALID,U8,ALAW,ULAW,S16LE,S16BE,F32LE,F32BE,S32LE,S32BE,S24LE,S24BE,S2432LE,S2432BE,MAX=(-1..12).to_a
  end
  module StreamDirection
    NODIRECTION,PLAYBACK,RECORD,UPLOAD=(0..3).to_a
  end
  module Simple
    extend Fiddle::Importer
    dlload 'libpulse-simple.so'

    SampleSpec = struct [
      'int sample_format',
      'uint32_t rate',
      'uint8_t channels'
    ]
    extern 'void * pa_simple_new ( const char * server, const char * name, int dir,const char * dev, const char * stream_name, const int * ss, const pa_channel_map * map, const pa_buffer_attr * attr,int * error );'
    extern 'int pa_simple_write ( void * s, const void * data, size_t bytes, int * error )'
    extern 'void pa_simple_free ( void * s )'
    extern 'uint64_t pa_simple_get_latency ( void * s, int * error )'
  end

  class SimpleO
    def handle_error code
      throw [code,"Error #{code} in #{caller[0]}"] unless 0 == code
    end
    def initialize name,desc,server:nil,device:nil,map:nil,buffer:nil,format:SampleFormat::F32LE,rate:44100,channels:2
      ps=Simple::SampleSpec.malloc
      ps.sample_format=format
      ps.rate=rate
      ps.channels=channels
      @err = 0
      @handle=Simple::pa_simple_new(server,name,StreamDirection::PLAYBACK,device,desc,ps,nil,nil,@err)
      handle_error @err
    end
    def write buf
      @err=0
      Simple::pa_simple_write @handle,buf,buf.length,@err
      handle_error @err
    end
    def free
      Simple::pa_simple_free @handle
      @handle=nil
    end
    def latency
      @err=0
      val=Simple::pa_simple_get_latency @handle,@err
      handle_error @err
      val
    end
    alias :close :free
  end
end

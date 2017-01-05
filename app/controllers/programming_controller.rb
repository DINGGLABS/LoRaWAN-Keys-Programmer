class ProgrammingController < ApplicationController
  before_action :get_programmers
  before_action :get_partnos
  before_action :get_ports
  before_action :get_baudrates

  # GET /programming
  def index
  
  end

  # POST /write_memory
  def write_memory
    #raise params.inspect

    if params[:conf_file].present?
      command = "avrdude -v -V -C #{params[:conf_file].tempfile.path} -c #{params[:programmer]} -p #{params[:partno]} -P #{params[:port]} -b #{params[:baudrate]}"

      # write flash
      if params[:hex_file].present?
        command += " -U flash:w:#{params[:hex_file].tempfile.path}:i"
      end

      # write eeprom
      if params[:eep_file].present?
        command += " -U eeprom:w:#{params[:eep_file].tempfile.path}:i"
      end

      # write lock fuse
      if params[:lock_fuse].present?
        command += " -U lock:w:0x#{params[:lock_fuse]}:m"
      end

      # write ext fuse
      if params[:ext_fuse].present?
        command += " -U efuse:w:0x#{params[:ext_fuse]}:m"
      end

      # write high fuse
      if params[:high_fuse].present?
        command += " -U hfuse:w:0x#{params[:high_fuse]}:m"
      end

      # write low fuse
      if params[:low_fuse].present?
        command += " -U lfuse:w:0x#{params[:low_fuse]}:m"
      end
      
      # print
      puts '==================================================================================================='
      puts command
      puts '==================================================================================================='
      
      # execute command
      response = `#{command}`
    else
      puts 'error: conf-File is missing!'
    end

    render :index
  end

  # POST /write_keys
  def write_keys
    raise params.inspect

  end

# //#define ADR                       true      // ADR enabled = true, disabled = false
# //#define DR                        5         // 5 = SF7 (default), 4 = SF8, 3 SF9, 2 = SF10, 1 = SF11, 0 = SF12
# //#define PWRIDX                    1         // 1 = 14dBm (default), 2 = 11dBm, 3 = 8dBm, 4 = 5dBm, 5 = 2dBm
# //#define RETX                      7         // 0... 255 (7 = default)

  private
    def get_programmers
      @programmers = %w(avrisp avrispv2 avrispmkII stk500v1 stk500v2 usbasp usbtiny)
      @default_programmer = 'stk500v1'
    end

    def get_partnos
      @partnos = %w(m328 m328p m328pb m32u2 m32u4 t45 t85)
      @default_partno = 'm328p'
    end

    def get_ports
      @ports = `ls /dev/{tty,cu}.*`.split("\n")
      #TODO: support Windows
    end

    def get_baudrates
      @baudrates = %w(9600 19200 38400 57600 115200 125000 230400 250000)
      @default_baudrate = '125000'
    end

end

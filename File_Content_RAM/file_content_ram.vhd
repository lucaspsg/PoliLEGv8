library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity ram is 

    generic(
        addr_s : natural := 64;
        word_s : natural := 32;
        init_f : string := "ram.dat"
    );
    port(
        ck : in bit;
        rd, wr : in bit; 
        addr : in bit_vector(addr_s - 1 downto 0);
        data_i : in bit_vector(word_s - 1 downto 0);
        data_o : out bit_vector(word_s - 1 downto 0)
    );

end ram;


architecture behavioral of ram is
    
    type mem_type is array (0 to 2 ** addr_s - 1) of bit_vector(word_s - 1 downto 0);

    impure function init_mem return mem_type is
        file text_file : text open read_mode is "ram.dat";
        variable text_line : line;
        variable mem_content : mem_type;
      begin
        for i in 0 to 2 ** addr_s - 1 loop
          readline(text_file, text_line);
          read(text_line, mem_content(i));
        end loop;
       
        return mem_content;
    end function;

    signal file_ram : mem_type := init_mem;

    begin

        process is 

            begin

                if rd = '1' then
                    data_o <= file_ram(to_integer(unsigned(addr)));

                elsif wr = '1' and ck = '1' then
                    file_ram(to_integer(unsigned(addr))) <= data_i;

                end if;

        end process;

end architecture; 

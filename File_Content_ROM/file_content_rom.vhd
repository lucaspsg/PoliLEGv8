library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity rom is 

    generic(
        addr_s : natural := 64;
        word_s : natural := 32;
        init_f : string := "rom.dat"
    );
    port(
        addr : in bit_vector(addr_s - 1 downto 0);
        data : out bit_vector(word_s - 1 downto 0)
    );
    
end rom;

architecture behavioral of rom is

    type mem_type is array (0 to 2 ** addr_s - 1) of bit_vector(word_s - 1 downto 0);

    impure function init_mem return mem_type is
        file text_file : text open read_mode is "rom.dat";
        variable text_line : line;
        variable mem_content : mem_type;
      begin
        for i in 0 to 2 ** addr_s - 1 loop
          readline(text_file, text_line);
          read(text_line, mem_content(i));
        end loop;
       
        return mem_content;
    end function;

    signal file_rom : mem_type := init_mem;

    begin

        data <= file_rom(to_integer(unsigned(addr)));

end architecture;
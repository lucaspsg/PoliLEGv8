library ieee;
use IEEE.numeric_bit.all;

entity simple_rom is

    port(
        addr : in bit_vector (3 downto 0);
        data : out bit_vector (7 downto 0)
    );

end simple_rom; 

architecture behavioral of simple_rom is 

    type mem_type is array (0 to 15) of bit_vector(7 downto 0);

    signal rom : mem_type := (
        "00000000",
        "00000011",
        "11000000",
        "00001100",
        "00110000",
        "01010101",
        "10101010",
        "11111111",
        "11100000",
        "11100111",
        "00000111",
        "00011000",
        "11000011",
        "00111100",
        "11110000",
        "00001111"
    );

    begin 

        data <= rom(to_integer(unsigned(addr)));

end architecture;

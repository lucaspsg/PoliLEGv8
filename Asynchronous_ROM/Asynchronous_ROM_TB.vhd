library ieee;
use IEEE.numeric_bit.all;

entity testbench is 
end testbench;

architecture exec of testbench is

    component simple_rom is

    port(
        addr : in bit_vector (3 downto 0);
        data : out bit_vector (7 downto 0)
    );
        
    end component; 

    signal addr_i : bit_vector (3 downto 0);
    signal data_o : bit_vector (7 downto 0);

    begin
        DUT: simple_rom port map(addr_i, data_o);

        process is
            
            begin

                addr_i <= "0000";
                
                wait for 100 ns;

                assert(data_o = "00000000") report "error on address 0" severity error;


                addr_i <= "0001";
                
                wait for 100 ns;

                assert(data_o = "00000011") report "error on address 1" severity error;


                addr_i <= "0010";
                
                wait for 100 ns;

                assert(data_o = "11000000") report "error on address 2" severity error;


                addr_i <= "0011";
                
                wait for 100 ns;

                assert(data_o = "00001100") report "error on address 3" severity error;


                addr_i <= "0100";
                
                wait for 100 ns;

                assert(data_o = "00110000") report "error on address 4" severity error;


                addr_i <= "0101";
                
                wait for 100 ns;

                assert(data_o = "01010101") report "error on address 5" severity error;


                addr_i <= "0110";
                
                wait for 100 ns;

                assert(data_o = "10101010") report "error on address 6" severity error;


                addr_i <= "0111";
                
                wait for 100 ns;

                assert(data_o = "11111111") report "error on address 7" severity error;


                addr_i <= "1000";
                
                wait for 100 ns;

                assert(data_o = "11100000") report "error on address 8" severity error;


                addr_i <= "1001";
                
                wait for 100 ns;

                assert(data_o = "11100111") report "error on address 9" severity error;


                addr_i <= "1010";
                
                wait for 100 ns;

                assert(data_o = "00000111") report "error on address 10" severity error;


                addr_i <= "1011";
                
                wait for 100 ns;

                assert(data_o = "00011000") report "error on address 11" severity error;


                addr_i <= "1100";
                
                wait for 100 ns;

                assert(data_o = "11000011") report "error on address 12" severity error;


                addr_i <= "1101";
                
                wait for 100 ns;

                assert(data_o = "00111100") report "error on address 13" severity error;


                addr_i <= "1110";
                
                wait for 100 ns;

                assert(data_o = "11110000") report "error on address 14" severity error;


                addr_i <= "1111";
                
                wait for 100 ns;

                assert(data_o = "00001111") report "error on address 15" severity error;

                wait for 100 ns;

                assert(0 = 1) report "testbench over" severity note;

                wait;

        end process;

end architecture;
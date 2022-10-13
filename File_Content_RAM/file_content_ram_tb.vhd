library ieee;
use ieee.numeric_bit.all;

entity testbench is 
end testbench;

architecture tb of testbench is

    component ram is 

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

    end component;

    signal ck_i, rd_i, wr_i : bit;
    signal addr_i : bit_vector(3 downto 0);
    signal data_ii, data_oo : bit_vector(7 downto 0);

    begin

        DUT : ram generic map(4, 8) port map(ck_i, rd_i, wr_i, addr_i, data_ii, data_oo);

        process is

            begin

                ck_i <= '0';
                rd_i <= '0';
                wr_i <= '0';
                addr_i <= "0000";
                data_ii <= "00000000";

                wait for 100 ns;

                ck_i <= '1';
                rd_i <= '1';
                wr_i <= '0';
                addr_i <= "0001";

                wait for 100 ns;

                assert data_oo = "00000011" report "error on read on address 1" severity error;

                wait for 100 ns;

                ck_i <= '0';
                rd_i <= '1';
                wr_i <= '0';
                addr_i <= "0011";

                wait for 100 ns;

                assert data_oo = "00001100" report "error on read on address 3" severity error;

                wait for 100 ns;

                ck_i <= '1';
                rd_i <= '0';
                wr_i <= '1';
                addr_i <= "0011";
                data_ii <= "00001000";

                wait for 100 ns;

                ck_i <= '0';
                rd_i <= '1';
                wr_i <= '0';
                addr_i <= "0011";

                wait for 100 ns;

                assert data_oo = "00001000" report "error on write on address 3" severity error;

                wait for 100 ns;

                ck_i <= '1';
                rd_i <= '0';
                wr_i <= '0';
                addr_i <= "1000";
                data_ii <= "00000000";

                wait for 100 ns;

                ck_i <= '0';
                rd_i <= '1';
                wr_i <= '0';
                addr_i <= "1000";

                wait for 100 ns;

                assert data_oo = "11100000" report "error on write on address 8, test with wr = 0" severity error;

                ck_i <= '0';
                rd_i <= '0';
                wr_i <= '1';
                addr_i <= "1000";
                data_ii <= "00000000";

                wait for 100 ns;

                ck_i <= '1';
                rd_i <= '1';
                wr_i <= '0';
                addr_i <= "1000";

                wait for 100 ns;

                assert data_oo = "11100000" report "error on write on address 8, test with ck = 0" severity error;

                wait for 100 ns;

                assert(0 = 1) report "testbench over" severity note;

                wait;

        end process;

end architecture;

        
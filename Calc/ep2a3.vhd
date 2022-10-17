library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;

entity calc is
    port(
        clock : in bit;
        reset : in bit;
        instruction : in bit_vector(15 downto 0);
        overflow : out bit;
        q1 : out bit_vector(15 downto 0)
    );
end calc;

architecture structural of calc is 

    component regfile is
        generic(
            regn : natural := 32;
            wordSize : natural := 64
        );
        port(
            clock : in bit;
            reset : in bit;
            regWrite : in bit;
            rr1, rr2, wr : in bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
            d : in bit_vector(wordSize - 1 downto 0);
            q1, q2 :out bit_vector(wordSize - 1 downto 0)
        );
    end component;

    component generic_adder is 

        generic(
            wordSize : natural := 64
        );

        port(
            n1, n2 : in bit_vector(wordSize - 1 downto 0);
            s : out bit_vector(wordSize - 1 downto 0);
            ov : out bit
        );

    end component;

    component sign_extend_5_to_16 is

        port(
            n : in bit_vector(4 downto 0);
            o : out bit_vector(15 downto 0)
        );
    
    end component;

    signal operation : bit;
    signal oper2 : bit_vector(4 downto 0);
    signal oper1 : bit_vector(4 downto 0);
    signal dest : bit_vector(4 downto 0);   
    
    signal extended_oper2 : bit_vector(15 downto 0);
    signal sum_n1, sum_n2, sum_result, sum_result_add, sum_result_add_i : bit_vector(15 downto 0);
    signal ov_add, ov_add_i : bit;

    begin

        sign_extend : sign_extend_5_to_16 port map(oper2, extended_oper2);

        reg_file : regfile generic map(32, 16) port map(clock, reset, '1', oper1, oper2, dest, sum_result, sum_n1, sum_n2);

        add : generic_adder generic map(16) port map(sum_n1, sum_n2, sum_result_add, ov_add);

        add_i : generic_adder generic map(16) port map(sum_n1, extended_oper2, sum_result_add_i, ov_add_i);


        overflow <= ov_add when operation = '1' else ov_add_i;

        sum_result <= sum_result_add when operation = '1' else sum_result_add_i;

        q1 <= sum_n1;

        process(clock, reset)

            begin

                if rising_edge(clock) then

                    operation <= instruction(15);
                    oper2 <= instruction(14 downto 10);
                    oper1 <= instruction(9 downto 5);
                    dest <= instruction(4 downto 0);

                end if;
            
        end process;

end architecture;





library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;

entity regfile is
    generic(
        regn : natural := 32;
        wordSize : natural := 64
    );
    port(
        clock : in bit;
        reset : in bit;
        regWrite : in bit;
        rr1, rr2, wr : in bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
        d : in bit_vector(wordSize - 1 downto 0);
        q1, q2 :out bit_vector(wordSize - 1 downto 0)
    );
end regfile;

architecture structural of regfile is

    component reg is
        generic(
            wordSize : natural := 4
        );
        port(
            clock : in bit; --entrada de clock
            reset : in bit; --clear assincrono
            load : in bit; --write enable (carga paralela)
            d : in bit_vector(wordSize - 1 downto 0); --entrada
            q : out bit_vector(wordSize - 1 downto 0) --saida
        );
    end component;

    type reg_array is array(0 to regn - 1) of bit_vector(wordSize - 1 downto 0);

    signal d_i : reg_array;
    signal q_o : reg_array;

    type write_bit_array is array(0 to regn - 1) of bit;

    signal we : write_bit_array;

    begin

        regs: for i in 0 to regn - 2 generate

            reg_x: reg generic map(wordSize) port map(clock, reset, we(i), d_i(i), q_o(i));

        end generate;

        last_reg: reg generic map(wordSize) port map(clock, '1', we(regn - 1), d_i(regn - 1), q_o(regn - 1));

        we(to_integer(unsigned(wr))) <= regWrite;
        d_i(to_integer(unsigned(wr))) <= d;
        q1 <= q_o(to_integer(unsigned(rr1)));
        q2 <= q_o(to_integer(unsigned(rr2))); 

end architecture;





library ieee;
use ieee.numeric_bit.all;

entity reg is
    generic(
        wordSize : natural := 4
    );
    port(
        clock : in bit; --entrada de clock
        reset : in bit; --clear assincrono
        load : in bit; --write enable (carga paralela)
        d : in bit_vector(wordSize - 1 downto 0); --entrada
        q : out bit_vector(wordSize - 1 downto 0) --saida
    );
end reg;

architecture dataflow of reg is
    
    begin

        process (clock, reset)

            begin
                
                if reset = '1' then
                        q <= (others => '0');

                elsif rising_edge(clock) and load = '1' then
                    q <= d;

                end if;
        end process;

end architecture;




library ieee;
use ieee.numeric_bit.all;

entity generic_adder is 

    generic(
        wordSize : natural := 64
    );

    port(
        n1, n2 : in bit_vector(wordSize - 1 downto 0);
        s : out bit_vector(wordSize - 1 downto 0);
        ov : out bit
    );

end entity;

architecture structural of generic_adder is 

    component bit_adder is

        port(
            b1, b2, cin : in bit;
            s, cout : out bit
        );

    end component;

    signal couts : bit_vector(wordSize - 1 downto 0);

    begin

        adder : for i in 1 to wordSize - 1 generate

            adder_x : bit_adder port map(n1(i), n2(i), couts(i - 1), s(i), couts(i));
        
        end generate;

        adder_0 : bit_adder port map(n1(0), n2(0), '0', s(0), couts(0));

        ov <= couts(wordSize - 1) xor couts(wordSize - 2);

end architecture;




library ieee;
use ieee.numeric_bit.all;

entity bit_adder is

    port(
        b1, b2, cin : in bit;
        s, cout : out bit
    );

end bit_adder;

architecture dataflow of bit_adder is

    begin
        
        s <= '1' when (b1 xor b2 xor cin) = '1' else '0';
        cout <= '1' when ((b1 and b2) or (b1 and cin) or (b2 and cin)) = '1' else '0';

end architecture;




library ieee;
use ieee.numeric_bit.all;

entity sign_extend_5_to_16 is

    port(
        n : in bit_vector(4 downto 0);
        o : out bit_vector(15 downto 0)
    );

end entity;

architecture behavioral of sign_extend_5_to_16 is

    signal zeros : bit_vector(10 downto 0) := (others => '0');

    begin

        o <= zeros & n when n(4) = '0' else not zeros & n;

end architecture;
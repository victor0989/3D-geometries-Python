library IEEE;
use IEEE.std_logic_1164.all;

entity my_fsm4 is
    port (
        X     : in  std_logic;
        CLK   : in  std_logic;
        RESET : in  std_logic;
        Y     : out std_logic_vector(1 downto 0);
        Z1    : out std_logic;
        Z2    : out std_logic
    );
end my_fsm4;

architecture fsm4 of my_fsm4 is
    type state_type is (ST0, ST1, ST2, ST3);
    signal PS, NS : state_type;
begin

    -- Proceso sincronizado (registro del estado)
    sync_proc : process(CLK)
    begin
        if RESET = '1' then
            PS <= ST0;
        elsif rising_edge(CLK) then
            PS <= NS;
        end if;
    end process;

    -- Proceso combinacional
    comb_proc : process(PS, X)
    begin
        -- Moore y Mealy outputs: valores por defecto
        Z1 <= '0';
        Z2 <= '0';

        case PS is
            when ST0 =>
                Z1 <= '1'; -- Moore output
                if X = '0' then
                    NS <= ST1;
                    Z2 <= '0'; -- Mealy output
                else
                    NS <= ST0;
                    Z2 <= '1';
                end if;

            when ST1 =>
                Z1 <= '1';
                if X = '0' then
                    NS <= ST2;
                    Z2 <= '0';
                else
                    NS <= ST1;
                    Z2 <= '1';
                end if;

            when ST2 =>
                Z1 <= '0';
                if X = '0' then
                    NS <= ST3;
                    Z2 <= '0';
                else
                    NS <= ST2;
                    Z2 <= '1';
                end if;

            when ST3 =>
                Z1 <= '1';
                if X = '0' then
                    NS <= ST0;
                    Z2 <= '0';
                else
                    NS <= ST3;
                    Z2 <= '1';
                end if;

            when others =>
                Z1 <= '1';
                Z2 <= '0';
                NS <= ST0;
        end case;
    end process;

    -- Salida codificada del estado actual
    with PS select
        Y <= "00" when ST0,
             "01" when ST1,
             "10" when ST2,
             "11" when ST3,
             "00" when others;

end fsm4;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dpRam is
  Port (ramClk: IN std_logic;
        WE_a: IN std_logic;
        WE_b: IN std_logic;
        addr_a: IN std_logic_vector (15 DOWNTO 0);
        addr_b: IN std_logic_vector (15 DOWNTO 0);
        dataIn_a: IN std_logic_vector (15 DOWNTO 0);
        dataIn_b: IN std_logic_vector (15 DOWNTO 0);
        dataOut_a: OUT std_logic_vector (15 DOWNTO 0);
        dataOut_b: OUT std_logic_vector (15 DOWNTO 0)
        );
end dpRam;

architecture dpRam_beh of dpRam is
    TYPE matrix IS ARRAY (0 TO 9999) OF std_logic_vector (15 DOWNTO 0);
    SHARED VARIABLE Ram: matrix;

begin
--    PROCESS(ramClk)
    PROCESS(WE_a, addr_a, dataIn_a)
    BEGIN
--        IF (rising_edge(ramClk)) THEN
            IF (WE_a = '1') THEN 
                Ram(Conv_Integer(addr_a)) := dataIn_a;
            ELSE
                dataOut_a <= Ram(Conv_Integer(addr_a));
            END IF;
--        END IF;
    END PROCESS;
    
--    PROCESS(ramClk)
    PROCESS(WE_b, addr_b, dataIn_b)
    BEGIN
--        IF (rising_edge(ramClk)) THEN 
            IF (WE_b = '1') THEN 
                Ram(Conv_Integer(addr_b)) := dataIn_b;
            ELSE
                dataOut_b <= Ram(Conv_Integer(addr_b));
            END IF;
--        END IF;
    END PROCESS;    

end dpRam_beh;

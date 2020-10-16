library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MemCTB is
end MemCTB;

architecture MemCTB_beh of MemCTB is
COMPONENT MemC IS
Port (WE: IN STD_LOGIC;
      addr: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      dataIn: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      dataOut: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
END COMPONENT;

signal WE_s: std_logic := '0';
signal addr_s: std_logic_vector (3 DOWNTO 0) := x"0";
signal dataIn_s, dataOut_s: std_logic_vector (15 DOWNTO 0):= x"0000";

begin

MatC: MemC PORT MAP (WE => WE_s, addr => addr_s, dataIn => dataIn_s, dataOut => dataOut_s);

PROCESS
BEGIN

    WAIT FOR 10 ns;
    
    WE_s <= '1';
--    dataIn_s <= x"0000";
    FOR I IN 0 TO 3 LOOP
        dataIn_s <= dataIn_s + x"0001";
        WAIT FOR 10 ns;
        addr_s <= addr_s + x"1";
    END LOOP;
    dataIn_s <= dataIn_s + x"0001";
    WAIT FOR 5 ns;
    WE_s <= '0';
    
    WAIT FOR 20 ns;
    
    addr_s <= x"0";
    WAIT FOR 10 ns;
    FOR J IN 0 TO 3 LOOP
        addr_s <= addr_s + x"1";
        WAIT FOR 10 ns;
    END LOOP;
    WAIT;
    

END PROCESS;


end MemCTB_beh;

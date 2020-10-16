library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity matrixMultiplier2TB is
end matrixMultiplier2TB;

architecture matrixMultiplier2TB_beh of matrixMultiplier2TB is

COMPONENT matrixMultiplier2 IS
Port (productOut: OUT std_logic_vector (15 DOWNTO 0);
      Clk: IN std_logic;
      Rst: IN std_logic;
      GO: IN std_logic;
      p1WEA: IN std_logic:= '0';
      p1WEB: IN std_logic:= '0';
      p1WEC: IN std_logic:= '0';
      p1addrA: IN std_logic_vector (15 DOWNTO 0):= x"0000";
      p1addrB: IN std_logic_vector (15 DOWNTO 0):= x"0000";
      p1addrC: IN std_logic_vector (15 DOWNTO 0):= x"0000";
      p1dataInA: IN std_logic_vector (15 DOWNTO 0);
      p1dataInB: IN std_logic_vector (15 DOWNTO 0);
      p1dataInC: IN std_logic_vector (15 DOWNTO 0);
      p1dataOutA: OUT std_logic_vector(15 DOWNTO 0):= x"0000";
      p1dataOutB: OUT std_logic_vector(15 DOWNTO 0):= x"0000";
      p1dataOutC: OUT std_logic_vector(15 DOWNTO 0):= x"0000"
      );
END COMPONENT;

signal Clk_s, Rst_s, GO_s, WEA_s, WEB_s, WEC_s, doneA, doneB: std_logic:= '0';
signal productOut_s, addrA_s, addrB_s, addrC_s, dataInA_s, dataInB_s, dataInC_s: std_logic_vector (15 DOWNTO 0):= x"0000";
signal dataOutA_s, dataOutB_s, dataOutC_s: std_logic_vector (15 DOWNTO 0):= x"0000";

begin

    multiplier: matrixMultiplier2 PORT MAP (productOut => productOut_s, Clk => Clk_s, Rst => Rst_s, GO => GO_s,
                                            p1WEA => WEA_s, p1WEB => WEB_s, p1WEC => WEC_s,
                                            p1addrA => addrA_s, p1addrB => addrB_s, p1addrC => addrC_s,
                                            p1dataInA => dataInA_s, p1dataInB => dataInB_s, p1dataInC => dataInC_s,
                                            p1dataOutA => dataOutA_s, p1dataOutB => dataOutB_s, p1dataOutC => dataOutC_s);
    
    ClockProcess: PROCESS
    BEGIN
        Clk_s <= '0';
        WAIT FOR 2 ps;
        Clk_s <= '1';
        WAIT FOR 2 ps;
    END PROCESS ClockProcess;
    
    RamAWriteProcess: PROCESS
    BEGIN
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        FOR I IN 0 TO 9999 LOOP
            WEA_s <=  '1';
            addrA_s <= std_logic_vector(to_unsigned(I, 16));
            IF (I mod 2 = 0) THEN
                dataInA_s <= x"0002";
            ELSE
                dataInA_s <= x"0003";
            END IF;
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
            WEA_s <= '0';
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        END LOOP; 
        doneA <= '1';
        
        WAIT FOR 10 ps;
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        FOR I IN 0 TO 9999 LOOP
            WEA_s <=  '0';
            addrA_s <= std_logic_vector(to_unsigned(I, 16));
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        END LOOP;
        
        WAIT;
    END PROCESS RamAWriteProcess;
    
    RamBWriteProcess: PROCESS
    BEGIN
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        FOR I IN 0 TO 99 LOOP
            WEB_s <=  '1';
            addrB_s <= std_logic_vector(to_unsigned(I, 16));
            IF (I mod 2 = 0) THEN
                dataInB_s <= x"0002";
            ELSE
                dataInB_s <= x"0003";
            END IF;
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
            WEB_s <= '0';
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        END LOOP;
        doneB <= '1';
        
        WAIT FOR 10 ps;
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        FOR I IN 0 TO 99 LOOP
            WEB_s <=  '0';
            addrB_s <= std_logic_vector(to_unsigned(I, 16));
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        END LOOP;
        
        WAIT;
    END PROCESS RamBWriteProcess;
    
    MultiplyProcess: PROCESS
    BEGIN
        WAIT UNTIl doneA = '1' AND doneB = '1';
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        Rst_s <= '1';
        GO_s <= '1';
        WAIT UNTIL Clk_s='1' AND Clk_s'EVENT;
        Rst_s <= '0';
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        GO_s <= '0';
        WAIT FOR 161700 ps;
        
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        FOR I IN 0 TO 99 LOOP
            WEC_s <=  '0';
            addrC_s <= std_logic_vector(to_unsigned(I, 16));
            WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        END LOOP;
        
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        addrC_s <= x"0000";
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        addrC_s <= x"0001";
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        addrC_s <= x"0050";
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        addrC_s <= x"0051";
        WAIT UNTIL Clk_s = '1' AND Clk_s'EVENT;
        addrC_s <= x"0063";
        
        
        WAIT;
    END PROCESS MultiplyProcess;


end matrixMultiplier2TB_beh;

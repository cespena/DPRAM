library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity MatrixMultiplicationTB is
end MatrixMultiplicationTB;

architecture MatrixMultiplicationTB_beh of MatrixMultiplicationTB is
COMPONENT matrixMultiplier IS
Port (Clk: IN std_logic;
      Rst: IN std_logic; 
      GO: IN std_logic;
      dataA: IN std_logic_vector (15 DOWNTO 0);
      dataB: IN std_logic_vector (15 DOWNTO 0);
      dataC: OUT std_logic_vector(15 DOWNTO 0);
      addrA: OUT std_logic_vector (7 DOWNTO 0);
      addrB: OUT std_logic_vector (7 DOWNTO 0);
      addrC: OUT std_logic_vector (7 DOWNTO 0);
      WE: OUT std_logic
      );
END COMPONENT;

COMPONENT MemA IS
Port (addr: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
END COMPONENT;

COMPONENT MemB IS 
Port (addr: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
END COMPONENT;

COMPONENT MemC IS
Port (WE: IN STD_LOGIC;
      addr: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      dataIn: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      dataOut: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
END COMPONENT;

signal Clk_s, Rst_s, GO_s, WE_s: std_logic:= '0';
signal dataA_s, dataB_s, dataC_s, dataOut_s: std_logic_vector (15 DOWNTO 0);
signal addrA_s, addrB_s, addrC_s: std_logic_vector (7 DOWNTO 0):= x"00";

begin
    MatMultiplier: matrixMultiplier PORT MAP (Clk => Clk_s,
                                              Rst => Rst_s,
                                              GO => GO_s, 
                                              dataA => dataA_s, 
                                              dataB => dataB_s, 
                                              dataC => dataC_s, 
                                              addrA => addrA_s,
                                              addrB => addrB_s, 
                                              addrC => addrC_s,
                                              WE => WE_s);
    MatA: MemA PORT MAP (addr => addrA_s, data => dataA_s);
    MatB: MemB PORT MAP (addr => addrB_s, data => dataB_s);
    MatC: MemC PORT MAP (WE => WE_s, addr => addrC_s, dataIn => dataC_s, dataOut => dataOut_s);



    ClockProcess: PROCESS
    BEGIN
        Clk_s <= '0';
        WAIT FOR 2 ns;
        Clk_s <= '1';
        WAIT FOR 2 ns;
    END PROCESS ClockProcess;
    
    MultiplyProcess: PROCESS
    BEGIN
        WAIT FOR 5 ns;
        
        Rst_s <= '1';
        GO_s <= '1';
        WAIT UNTIL Clk_s='1' AND Clk_s'EVENT;
        WAIT FOR 5 ns;
        Rst_s <= '0';
        WAIT FOR 5 ns;
        GO_s <= '0';
        WAIT FOR 500 ns;
        
        WAIT;
    END PROCESS MultiplyProcess;



end MatrixMultiplicationTB_beh;
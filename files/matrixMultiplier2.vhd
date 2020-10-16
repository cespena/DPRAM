library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity matrixMultiplier2 is
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
end matrixMultiplier2;

architecture matrixMultiplier2_beh of matrixMultiplier2 is

COMPONENT dpRam IS
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
END COMPONENT;


TYPE Statetype IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
signal StateReg: Statetype := S0;
signal I, J: INTEGER:= 0;
signal product: std_logic_vector (15 DOWNTO 0) := x"0000";

signal p2WEA, p2WEB, p2WEC: std_logic:= '0';
signal p2addrA, p2addrB, p2addrC: std_logic_vector (15 DOWNTO 0);
signal p2dataInA, p2dataInB, p2dataInC: std_logic_vector (15 DOWNTO 0);
signal p2dataOutA, p2dataOutB, p2dataOutC: std_logic_vector (15 DOWNTO 0); 


begin
    RamA: dpRam PORT MAP (ramClk => Clk,
                          WE_a => p1WEA, 
                          WE_b => p2WEA,
                          addr_a => p1addrA, 
                          addr_b => p2addrA,
                          dataIn_a => p1dataInA,
                          dataIn_b => p2dataInA,
                          dataOut_a => p1dataOutA,
                          dataOut_b => p2dataOutA
                          );

    RamB: dpRam PORT MAP (ramClk => Clk,
                          WE_a => p1WEB, 
                          WE_b => p2WEB,
                          addr_a => p1addrB, 
                          addr_b => p2addrB,
                          dataIn_a => p1dataInB,
                          dataIn_b => p2dataInB,
                          dataOut_a => p1dataOutB,
                          dataOut_b => p2dataOutB
                          );
                                
    RamC: dpRam PORT MAP (ramClk => Clk,
                          WE_a => p1WEC, 
                          WE_b => p2WEC,
                          addr_a => p1addrC, 
                          addr_b => p2addrC,
                          dataIn_a => p1dataInC,
                          dataIn_b => p2dataInC,
                          dataOut_a => p1dataOutC,
                          dataOut_b => p2dataOutC
                          );


    PROCESS(Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            IF (Rst = '1') THEN
                StateReg <= S0;
                I <= 0;
                J <= 0; 
                product <= x"0000";
                p2WEA <= '0';
                p2WEB <= '0';
                p2WEC <= '0';
            ELSE
                CASE (StateReg) IS
                WHEN S0 =>
                    IF (GO = '1') THEN
                        StateReg <= S1;
                    END IF;
                
                WHEN S1 =>
                    I <= 0;
                    StateReg <= S2;
                
                WHEN S2 =>
                    J <= 0;
                    product <= x"0000";
                    p2WEA <= '0';
                    p2WEB <= '0';
                    p2WEC <= '0';
                    StateReg <= S3;
                
                WHEN S3 =>
                    p2addrA <= std_logic_vector(std_logic_vector(to_unsigned((I * 100), 16)) + std_logic_vector(to_unsigned(J, 16)));
                    p2addrB <= std_logic_vector(to_unsigned(J, 16));
                    StateReg <= S4;

                WHEN S4 => 
                    product <= product + std_logic_vector(to_unsigned((Conv_Integer(p2dataOutA) * Conv_Integer(p2dataOutB)), 16));
                    productOut <= product;
                    StateReg <= S5;
                 
                WHEN S5 =>
                    J <=  J + 1;
--                    productOut <= product;
                    StateReg <= S6;
                    
                WHEN S6 =>
                    IF (J = 100) THEN 
                        StateReg <= S7;
                    ELSE
                        StateReg <= S3;
                    END IF;
                    
                WHEN S7 =>
                    p2addrC <= std_logic_vector(to_unsigned(I, 16));
                    p2WEC <= '1';
                    p2dataInC <= product;
                    StateReg <= S8;
                    
                WHEN S8 =>
                    p2WEC <= '0';
                    I <= I + 1;
                    StateReg <= S9;
                    
                WHEN S9 =>
                    IF (I /= 100) THEN
                        StateReg <= S2;
                    ELSE
                        StateReg <= S0;
                    END IF;
                
                WHEN OTHERS =>
                    StateReg <= S0;
                END CASE;
            END IF;
        END IF;
    END PROCESS;
end matrixMultiplier2_beh;
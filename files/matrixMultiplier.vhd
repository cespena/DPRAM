library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity matrixMultiplier is
  Port (Clk: IN std_logic;
        Rst: IN std_logic;
        GO: IN std_logic;
        dataA: IN std_logic_vector (15 DOWNTO 0);
        dataB: IN std_logic_vector (15 DOWNTO 0);
        dataC: OUT std_logic_vector(15 DOWNTO 0):= x"0000";
        addrA: OUT std_logic_vector (7 DOWNTO 0):= x"00";
        addrB: OUT std_logic_vector (7 DOWNTO 0):= x"00";
        addrC: OUT std_logic_vector (7 DOWNTO 0):= x"00";
        WE: OUT std_logic:= '0'
        );
end matrixMultiplier;

architecture matrixMultiplier_beh of matrixMultiplier is
TYPE Statetype IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
signal StateReg: Statetype := S0;
signal I, J: INTEGER:= 0;
signal product: std_logic_vector (15 DOWNTO 0) := x"0000";

begin
    PROCESS(Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            IF (Rst = '1') THEN
                StateReg <= S0;
                I <= 0;
                J <= 0; 
                product <= x"0000";
                WE <= '0';
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
                    WE <= '0';
                    StateReg <= S3;
                
                WHEN S3 =>
                    addrA <= std_logic_vector(std_logic_vector(to_unsigned((I * 5), 8)) + std_logic_vector(to_unsigned(J, 8)));
                    addrB <= std_logic_vector(to_unsigned(J, 8));
                    StateReg <= S4;
                    
                WHEN S4 => 
                    product <= product + std_logic_vector(to_unsigned((Conv_Integer(dataA) * Conv_Integer(dataB)), 16));
                    StateReg <= S5;
                 
                WHEN S5 =>
                    J <=  J + 1;
                    StateReg <= S6;
                    
                WHEN S6 =>
                    IF (J = 5) THEN 
                        StateReg <= S7;
                    ELSE
                        StateReg <= S3;
                    END IF;
                    
                WHEN S7 =>
                    addrC <= std_logic_vector(to_unsigned(I, 8));
                    WE <= '1';
                    dataC <= product;
                    StateReg <= S8;
                    
                WHEN S8 =>
                    WE <= '0';
                    I <= I + 1;
                    StateReg <= S9;
                    
                WHEN S9 =>
                    IF (I /= 5) THEN
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
end matrixMultiplier_beh;

-- x"37" 55
-- x"82" 130
-- x"cd" 205
-- x"118" 280
-- x"163" 355
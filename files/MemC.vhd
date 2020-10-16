library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity MemC is
  Port (WE: IN STD_LOGIC;
        addr: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        dataIn: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        dataOut: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
end MemC;

architecture MemC_beh of MemC is
    TYPE matrix IS ARRAY (0 TO 4) OF std_logic_vector (15 DOWNTO 0);
    SHARED VARIABLE MatrixC: matrix;

begin
    PROCESS (addr, WE)
    BEGIN
        IF (WE = '1') THEN 
            MatrixC(Conv_Integer(addr)) := dataIn;
        ELSE
            dataOut <= MatrixC(Conv_Integer(addr));
        END IF;
    END PROCESS;

end MemC_beh;

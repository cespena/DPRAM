library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MemA is
  Port (addr: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        data: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
end MemA;

architecture MemA_beh of MemA is
    TYPE matrix IS ARRAY (0 TO 24) OF std_logic_vector (15 DOWNTO 0);
    
    CONSTANT MatrixA: matrix := (
        x"0001", x"0002", x"0003", x"0004", x"0005",
        x"0006", x"0007", x"0008", x"0009", x"000a",
        x"000b", x"000c", x"000d", x"000e", x"000f",
        x"0010", x"0011", x"0012", x"0013", x"0014",
        x"0015", x"0016", x"0017", x"0018", x"0019"    
    ); 

begin
    PROCESS (addr)
    BEGIN
        data <= MatrixA(Conv_Integer(addr));
    END PROCESS;


end MemA_beh;
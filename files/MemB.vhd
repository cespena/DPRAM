library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MemB is
  Port (addr: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
      );
end MemB;

architecture MemB_beh of MemB is
    TYPE matrix IS ARRAY (0 TO 4) OF std_logic_vector (15 DOWNTO 0);
    
    CONSTANT MatrixB: matrix := (
    x"0001",
    x"0002",
    x"0003",
    x"0004",
    x"0005"
    );

begin
    PROCESS(addr)
    BEGIN
        data <= MatrixB(Conv_Integer(addr));
    END PROCESS;

end MemB_beh;

--Lincoln Hatlestad and Doyle Chism
--shift_left2.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity shift_left2 is
    port(
    DataIn: in std_logic_vector(25 downto 0);
    shiftedData: out std_logic_vector(27 downto 0));
end shift_left2;

architecture dataflow of shift_left2 is

begin

    shiftedData <= DataIn(25 downto 0) & "00";

end dataflow;
-- Copyright (C) 1991-2011 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/20/2018 14:10:45"
                                                            
-- Vhdl Test Bench template for design  :  emiss_rs232
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY emiss_rs232_vhd_tst IS
END emiss_rs232_vhd_tst;
ARCHITECTURE emiss_rs232_arch OF emiss_rs232_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Clk : STD_LOGIC;
SIGNAL ledR : STD_LOGIC;
SIGNAL q_bram : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL raddress_bram : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL rst : STD_LOGIC;
SIGNAL sw : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL txd_obs : STD_LOGIC;
SIGNAL txd_out : STD_LOGIC;
COMPONENT emiss_rs232
	PORT (
	Clk : IN STD_LOGIC;
	ledR : OUT STD_LOGIC;
	q_bram : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	raddress_bram : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	rst : IN STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	txd_obs : OUT STD_LOGIC;
	txd_out : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : emiss_rs232
	PORT MAP (
-- list connections between master ports and signals
	Clk => Clk,
	ledR => ledR,
	q_bram => q_bram,
	raddress_bram => raddress_bram,
	rst => rst,
	sw => sw,
	txd_obs => txd_obs,
	txd_out => txd_out
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END emiss_rs232_arch;

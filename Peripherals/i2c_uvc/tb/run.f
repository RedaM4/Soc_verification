////////////////////////////////////////
// option
////////////////////////////////////////



############Saving run Output to a Log File/##########
-l sim.log





############select test###########
+UVM_TESTNAME=i2c_write_read_test
//+UVM_TESTNAME=i2c_all_address_test



##############debug#################

##+UVM_CONFIG_DB_TRACE
##+UVM_OBJECTION_TRACE




############verbosity level###########
//+UVM_VERBOSITY=UVM_LOW
//+UVM_VERBOSITY=UVM_MEDIUM
+UVM_VERBOSITY=UVM_HIGH



############ gui#############
//-gui
//+access+rwc



// default timescale
-timescale 1ns/1ns


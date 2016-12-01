#include "lrs.h" //must include this, otherwise fail

Action()
{
	int result;
	lr_start_transaction("telnet_test");
	lrs_create_socket("socket0", "TCP", "LocalHost=0", "RemoteHost=HOST:PORT", LrsLastArg);

	lrs_send("socket0", "buf0", LrsLastArg);
	lrs_receive("socket0", "buf1", LrsLastArg);

	lrs_send("socket0", "buf2", LrsLastArg);
	lrs_save_param("socket0", NULL, "param1", 0, 22);
	lr_output_message ("param1: %s", lr_eval_string("{param1}"));

	lrs_close_socket("socket0");
	

	if (strcmp(lr_eval_string("{param1}"), "match this text") == 0){
		lr_output_message("buffer matches requirements");
		lr_end_transaction("telnet_test", LR_PASS);	
	} else {
		lr_error_message("buffer does not match requirements");
		lr_end_transaction("telnet_test", LR_FAIL);
	}
	
	return 0;
}

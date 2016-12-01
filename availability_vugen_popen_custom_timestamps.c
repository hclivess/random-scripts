extern char* strtok(char *token, const char *delimiter); // Explicit declaration required for functions that do not return an int.
 
#define BUFFER_SIZE 10240 // 10 KB
 
Action()
{
	
	extern double atof(); //vugen hack

    long fp; // file/stream pointer
    int count; // number of characters that have been read from the stream.
    char buffer[BUFFER_SIZE]; // allocate memory for the output of the command.
    char * token;
    char param_buf[10]; // buffer to hold the parameter name.
    int i;
    double d;
    
    /*
     * Running a command, and splitting the output into separate parameters for each element.
     */ 

    fp = popen("c:\\SCRIPT.py", "r");
    if (fp == NULL) {
        lr_error_message("Error opening stream.");
        return -1;
    }
 
    count = fread(buffer, sizeof(char), BUFFER_SIZE, fp); // read up to 10KB
    if (feof(fp) == 0) {
        lr_error_message("Did not reach the end of the input stream when reading. Try increasing BUFFER_SIZE.");
        return -1;
    }
    if (ferror(fp)) {
        lr_error_message ("I/O error during read."); 
        return -1;
    }
    buffer[count] = NULL;
 
    // Split the stream at each newline character, and save them to a parameter array.
    token = (char*) strtok(buffer, "\n"); // Get the first token 
 
    if (token == NULL) { 
        lr_error_message ("No tokens found in string!"); 
        return -1; 
    }
 
    i = 1;
    while (token != NULL) { // While valid tokens are returned 
        sprintf(param_buf, "output_%d", i);
        lr_save_string(token, param_buf);
        i++;
        token = (char*) strtok(NULL, "\n"); 
    }
    lr_save_int(i-1, "output_count");
 
    // Print all values of the parameter array.
    for (i=1; i<=lr_paramarr_len("output"); i++) {
        lr_output_message("Parameter value: %s", lr_paramarr_idx("output", i));
        
        if (i==1){ //define which iteration is timestamp on this line
        	lr_output_message("Timestamp is: %s", lr_paramarr_idx("output", i));
        	d = atof(lr_eval_string(lr_paramarr_idx("output", i)));
        	lr_output_message("%f", d);
        	}
        
        if (i==lr_paramarr_len("output")) {
        	lr_output_message("Status is: %s", lr_paramarr_idx("output", i));
        	
	  if (strcmp(lr_paramarr_idx("output", i), "OK") == 0) {
	    lr_output_message("string1 and string2 match using strcmp");
	    lr_set_transaction("TRANSACTION_NAME", d, LR_PASS);

	  } else {
	    lr_output_message("string1 and string2 do not match using strcmp");
	    lr_set_transaction("TRANSACTION_NAME", d, LR_FAIL);
	  }


        }

    }
 	

    
    pclose(fp);
 
    return 0;
}

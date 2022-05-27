class error {
  convert_to_error(str) {
    return '\x1b[31m' + str.split(']')[0] + ']' + '\x1B[0m' + str.split(']')[1];
  }
}

var print_error = new error();

String error_1 = print_error.convert_to_error('[error_1] No kernel provided.');
String error_2 =
    print_error.convert_to_error('[error_2] Please give a valid command.');
String error_3 =
    print_error.convert_to_error('[error_3] Please give a valid kernel.');
String error_4 = print_error.convert_to_error(
    '[error_4] %kernel not found on kernel.ubuntu.com try another one.');
String error_5 = print_error.convert_to_error(
    '[error_5] wsl command can only be used to install wsl kernels on wsl2.');
String error_6 = print_error
    .convert_to_error('[error_6] Nvidia cards are unsupported by trident.');
String error_7 = print_error
    .convert_to_error('[error_7] File missing when building was complete.');
String error_8 = print_error.convert_to_error(
    '[error_8] Run the command with only one - or run -help to list all the commands.');
String error_9 = print_error.convert_to_error(
    '[error_9] Failed to fetch latest release: can\'t check for updates.');
String error_10 =
    print_error.convert_to_error('[error_10] Operating system not supported.');
String error_11 = print_error
    .convert_to_error('[error_11] Failed to download and install kernel.');
String error_12 = print_error.convert_to_error(
    '[error_12] The kernel you want to install is lower than what you currently have.');
String error_13 = print_error.convert_to_error(
    '[error_13] You need a minimum of 2 threads to successfully compile linux with Trident.');
String error_14 = print_error.convert_to_error(
    '[error_14] The wsl kernel conf file is higher than the kernel you want to install.');
String error_15 =
    print_error.convert_to_error('[error_15] Your system does not use apt.');
String error_16 = print_error
    .convert_to_error('[error_16] The wslvar command is not available.');

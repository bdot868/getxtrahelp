<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
    <head>
        <meta name="viewport" content="width=device-width" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title><?php echo getenv('WEBSITE_NAME'); ?></title>
        <style>
            img {
                max-width: 100%;
            }
            body {
                -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%;
            }
            @media only screen and (max-width: 600px) {
                a[class="btn"] {
                    display: block !important; margin-bottom: 10px !important; background-image: none !important; margin-right: 0 !important;
                }
                div[class="column"] {
                    width: auto !important; float: none !important;
                }
                table.social div[class="column"] {
                    width: auto !important;
                }
            }
        </style>
    </head>
    <body bgcolor="#FFFFFF" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: none; width: 100% !important; height: 100%; margin: 0; padding: 0;">
        <table bgcolor="#ffffff" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
            <tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto; padding: 0;">

                    <div style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; max-width: 600px; display: block; margin: 0 auto; padding: 15px;">
                        <table bgcolor="#ffffff" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
                            <tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0; text-align: center;">
                                    <img src="<?php echo base_url() ?>/assets/img/mailLogo.png" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; max-width: 200px; margin: 0; padding: 0;" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
            </tr>
        </table>
        <table style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
            <tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
                <td bgcolor="#FFFFFF" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto; padding: 0;">
                    <div style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; max-width: 600px; display: block; margin: 0 auto; padding: 15px;">
                        <table style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
                            <tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                                    <h3 style="font-family: &quot;HelveticaNeue-Light&quot;, &quot;Helvetica Neue Light&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, &quot;Lucida Grande&quot;, sans-serif; line-height: 1.5; color: #000; font-weight: 500; font-size: 27px; margin: 0 0 15px; padding: 0;">
                                        Thanks For Registering with <?php echo getenv('WEBSITE_NAME'); ?>!
                                    </h3>
                                    <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
                                        Dear <b style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"><?php echo (!empty($user->firstName) ? $user->firstName : $user->email); ?></b>.
                                    </p>
                                    
                                    <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
                                        Please enter the following verification code to activate your account.
                                    </p>

                                    <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
                                        Your account activation code is:  <b style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"><?php echo $user->verificationCode ?></b>.
                                    </p>

                                    <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
                                        Sincerely,</br>
                                        <?php echo getenv('WEBSITE_NAME'); ?></br>
                                    </p>

                                    <br style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
                                    <br style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
            </tr>
        </table>
        <table style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; width: 100%; clear: both !important; margin: 0; padding: 0;">
            <tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto; padding: 0;">
                    <div style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; max-width: 600px; display: block; margin: 0 auto; padding: 15px;">
                        <table style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; width: 100%; margin: 0; padding: 0;">
                            <tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                                <td align="center" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
                                    <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 14px; line-height: 1.6; margin: 0 0 10px; padding: 0;">© <?php echo date("Y")." ".getenv('WEBSITE_NAME'); ?> All rights reserved.</p>
                                    <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 14px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
                                        <a href="https://getxtrahelp.com/terms-conditions" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; color: #2BA6CB; margin: 0; padding: 0;">Terms</a> |
                                        <a href="https://getxtrahelp.com/privacy-policy" style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; color: #2BA6CB; margin: 0; padding: 0;">Privacy</a>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </div>

                </td>
                <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"></td>
            </tr>
        </table>

    </body>
</html>
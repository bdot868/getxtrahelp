<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); ?>
<?php $this->load->view('Mail/MailHeader'); ?>
<tr style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
    <td style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;">
        <h3 style="font-family: &quot;HelveticaNeue-Light&quot;, &quot;Helvetica Neue Light&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, &quot;Lucida Grande&quot;, sans-serif; line-height: 1.5; color: #000; font-weight: 500; font-size: 27px; margin: 0 0 15px; padding: 0;">
            <?php echo getenv('WEBSITE_NAME') ?> Forgot Password. 
        </h3>
        <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
            Dear <b style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"><?php echo (!empty($user->firstName) ? $user->firstName : $user->email); ?></b>.
        </p>

        <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
            Please enter the following verification code to reset your password.
        </p>

        <p style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; font-weight: normal; font-size: 17px; line-height: 1.6; margin: 0 0 10px; padding: 0;">
           Your account Code :  <b style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;"><?php echo $user->forgotCode ?></b>.
        </p>

        <br style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
        <br style="font-family: &quot;Helvetica Neue&quot;, &quot;Helvetica&quot;, Helvetica, Arial, sans-serif; margin: 0; padding: 0;" />
    </td>
</tr>
<?php $this->load->view('Mail/MailFooter'); ?>
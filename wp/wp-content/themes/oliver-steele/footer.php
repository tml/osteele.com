<hr />
<div id="footer">
	<p>
		<?php bloginfo('name'); ?> is proudly powered by 
		<a href="http://wordpress.org">WordPress</a>
		<br /><a href="feed:<?php bloginfo('rss2_url'); ?>">Entries (RSS)</a>
		and <a href="feed:<?php bloginfo('comments_rss2_url'); ?>">Comments (RSS)</a>.
		<?php echo $wpdb->num_queries; ?> queries in <?php timer_stop(1); ?> seconds.
	</p>
</div>
</div>

<!-- Gorgeous design by Michael Heilemann - http://binarybonsai.com/kubrick/ -->
<?php /* "Just what do you think you're doing Dave?" */ ?>

		<?php do_action('wp_footer'); ?>

<script type='text/javascript' src='http://track.mybloglog.com/js/jsserv.php?mblID=2005120301543073'></script>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-202010-1";
urchinTracker();
</script>

</body>
</html>
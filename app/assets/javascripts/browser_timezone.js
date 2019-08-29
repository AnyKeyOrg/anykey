/*
 * Detects browser timezone
 * and sets it in a cookie
 */

var timezone = jstz.determine();
document.cookie = 'browser_timezone='+timezone.name()+';';
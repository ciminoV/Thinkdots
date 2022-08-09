/* user and group to drop privileges to */
static const char *user  = "cimino";
static const char *group = "wheel";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "#101010",     /* after initialization */
	[INPUT] =  "#434758",   /* during input */
	[FAILED] = "#282c34",   /* wrong password */
	[CAPS] = "#f07178",         /* CapsLock on */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* default message */
static const char * message = "Torno subito";

/* text color */
static const char * text_color = "#bbc2cf";

/* text size (must be a valid size) */
static const char * font_name = "6x13";

/* time to cancel lock with mouse movement in seconds */
static const int timetocancel = 10;

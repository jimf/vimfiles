"""
Utilities for formatting JavaScript snippets.
"""

ALWAYS = 'always'
NEVER = 'never'


def get_option(snip, option, default=None):
    return snip.opt('g:ultisnips_javascript["{}"]'.format(option), default)


def semi(snip):
    option = get_option(snip, 'semi', ALWAYS)

    if option == NEVER:
        return ''
    elif option == ALWAYS:
        return ';'
    else:
        return ';'


def space_before_function_paren(snip):
    option = get_option(snip, 'space-before-function-paren', NEVER)

    if option == NEVER:
        return ''
    elif option == ALWAYS:
        return ' '
    else:
        return ''


def keyword_spacing(snip):
    option = get_option(snip, 'keyword-spacing', ALWAYS)

    if option == NEVER:
        return ''
    elif option == ALWAYS:
        return ' '
    else:
        return ''

from django.template import Library

register = Library()


@register.filter(name='times')
def times(start, end):
    return range(start, end)


@register.filter(name='getphoto')
def getphoto(obj, index):
    prop = 'photo_' + str(index)
    if hasattr(obj, prop):
        return getattr(obj, prop)

    return False


@register.inclusion_tag('thumbnails.html')
def thumbnails(listing):
    photos = []
    for index in range(1, 6):
        if getphoto(listing, index):
            photos.append(getphoto(listing, index))

    return {'photos': photos}

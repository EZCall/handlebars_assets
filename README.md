handlebars_assets <img src="https://img.shields.io/badge/ruby%20-v2.6.3-brightgreen.svg" title="ruby">
===================

# Use handlebars.js templates with the asset pipeline and/or sprockets

# _NOTE_

Use original gem [handlebars_assets](https://github.com/leshill/handlebars_assets) when issue [#175](https://github.com/leshill/handlebars_assets/issues/175) will be solved.

# Installation

## Rails

Load `handlebars_assets` in your `Gemfile`

```ruby
gem 'handlebars_assets', github: 'EZCall/handlebars_assets', branch: 'main'
```

Then follow [Javascript Setup](#javascript-setup)

## Sprockets (Non-Rails)

`handlebars_assets` can work with earlier versions of Rails or other frameworks like Sinatra.

Load `handlebars_assets` in your `Gemfile`

```ruby
gem 'handlebars_assets', github: 'EZCall/handlebars_assets', branch: 'main'
```

Add the `HandlebarsAssets.path` to your `Sprockets::Environment` instance. This
lets Sprockets know where the Handlebars JavaScript files are and is required
for the next steps to work.

```ruby
env = Sprockets::Environment.new

require 'handlebars_assets'
env.append_path HandlebarsAssets.path
```

## Javascript Setup

Require `handlebars.runtime.js` in your JavaScript manifest (i.e. `application.js`)

```javascript
//= require handlebars.runtime
```

If you need to compile your JavaScript templates in the browser as well, you should instead require `handlebars.js` (which is significantly larger)

```javascript
//= require handlebars
```

### Templates directory

Generally you want to locate your template with your other assets, for example `app/assets/javascripts/templates`. In your JavaScript manifest file, use `require_tree` to pull in the templates

> app/assets/javascripts/application.js
```javascript
//= require_tree ./templates
```
This must be done before `//= require_tree .` otherwise all your templates will not have the intended prefix; and after your inclusion of handlebars/handlebars runtime.

## Rails Asset Precompiling

`handlebars_assets` also works when you are precompiling your assets.

### `rake assets:precompile`

If you are using `rake assets:precompile`, you have to re-run the `rake` command to rebuild any changed templates. See the [Rails guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) for more details.

### Heroku & other cloud hosts

If you are deploying to Heroku, be sure to read the [Rails guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) and in your `config/application.rb` set:

```ruby
config.assets.initialize_on_precompile = false
```

This avoids running your initializers when compiling assets (see the [guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) for why you would want that).


```ruby
config.assets.initialize_on_precompile = true
```

This will run all your initializers before precompiling assets.

# Usage

## The template files

Write your Handlebars templates as standalone files in your templates directory. Organize the templates similarly to Rails views.

For example, if you have new, edit, and show templates for a Contact model

```
templates/
  contacts/
    new.hbs
    edit.hbs
    show.hbs
```

Your file extensions tell the asset pipeline how to process the file. Use `.hbs` to compile the template with Handlebars.

If your file is `templates/contacts/new.hbs`, the asset pipeline will generate JavaScript code

1. Compile the Handlebars template to JavaScript code
1. Add the template code to the `HandlebarsTemplates` global under the name `contacts/new`

You can then invoke the resulting template in your application's JavaScript

NOTE: There will be no javascript object `HandlebarsTemplates` unless at least ONE template is included.

```javascript
HandlebarsTemplates['contacts/new'](context);
```

## Partials

If you begin the name of the template with an underscore, it will be recognized as a partial. You can invoke partials inside a template using the Handlebars partial syntax:

```
Invoke a {{> path/to/_partial }}
```

# Configuration

## The template namespace

By default, the global JavaScript object that holds the compiled templates is `HandlebarsTemplates`, but it can
be easily renamed. Another common template namespace is `JST`.  Just change the `template_namespace` configuration option
when you initialize your application.

```ruby
HandlebarsAssets::Config.template_namespace = 'JST'
```

## Ember Support

To compile your templates for use with [Ember.js](http://emberjs.com)
simply turn on the config option:

```ruby
HandlebarsAssets::Config.ember = true
```

If you need to compile templates for Ember and another framework then enable
multiple frameworks:

```ruby
HandlebarsAssets::Config.multiple_frameworks = true
```

After `mutliple_frameworks` has been enabled templates with the `.ember.hbs`
extension will be made available to Ember.

## `.hamlbars` and `.slimbars` Support

If you name your templates with the extension `.hamlbars`, you can use Haml syntax for your markup! Use `HandlebarsAssets::Config.haml_options` to pass custom options to the Haml rendering engine.

For example, if you have a file `widget.hamlbars` that looks like this:

```haml
%h1 {{title}}
%p {{body}}
```

The Haml will be pre-processed so that the Handlebars template is basically this:

```html
<h1> {{title}} </h1>
<p> {{body}} </p>
```

The same applies to `.slimbars` and the Slim gem. Use `HandlebarsAssets::Config.slim_options` to pass custom options to the Slim rendering engine.

<strong>Note:</strong> To use the `hb` handlebars helper with Haml, you'll also need to include the Hamlbars gem in your Gemfile:

```ruby
  gem 'hamlbars', '~> 2.0'
```

This will then allow you to do things like Haml blocks:

```haml
%ul.authors
= hb 'each authors' do
  %li<
    = succeed ',' do
      = hb 'lastName'
    = hb 'firstName'
```

Reference [hamlbars](https://github.com/jamesotron/hamlbars) for more information.

## Using another version of `handlebars.js`

Occasionally you might need to use a version of `handlebars.js` other than the included version. You can set the `compiler_path` and `compiler` options to use a custom version of `handlebars.js`.

```ruby
HandlebarsAssets::Config.compiler = 'my_handlebars.js' # Change the name of the compiler file
HandlebarsAssets::Config.compiler_path = Rails.root.join('app/assets/javascripts') # Change the location of the compiler file
```

## Patching `handlebars.js`

If you need specific customizations to the `handlebars.js` compiler, you can use patch the compiler with your own JavaScript patches.

The patch file(s) are concatenated with the `handlebars.js` file before compiling. Take a look at the test for details.

```ruby
HandlebarsAssets::Config.patch_files = 'my_patch.js'
HandlebarsAssets::Config.patch_path = Rails.root.join('app/assets/javascripts') # Defaults to `Config.compiler_path`
```

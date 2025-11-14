# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

Box Tracker is a Rails 8.1 application for organizing and tracking physical storage boxes. Users can create boxes with markdown-formatted contents, attach images, organize boxes into groups, and generate QR codes for quick access.

## Development Commands

### Running the Application
```bash
bin/setup          # Initial setup
bin/rails server   # Start development server
```

### Testing
```bash
rails test                    # Run all tests (parallel execution enabled)
rails test test/models        # Run model tests only
rails test test/controllers   # Run controller tests only
rails test test/system        # Run system tests only
rails test path/to/test.rb    # Run a single test file
rails test path/to/test.rb:10 # Run a single test at line 10
```

### Database
```bash
rails db:migrate       # Run pending migrations
rails db:reset         # Drop, create, migrate, and seed database
rails db:schema:load   # Load schema without running migrations
```

### Code Quality
```bash
rubocop                # Run Ruby linter (Omakase style)
brakeman              # Run security analysis
```

## Architecture

### Data Model

The application uses a many-to-many relationship pattern with explicit join tables:

- **Box** - Storage boxes with `display_name` and markdown `contents`
- **BoxGroup** - Collections of boxes with `display_name` and `notes`
- **Image** - Binary image storage with `data` and `content_type`
- **Join tables**: `box_images`, `box_group_images`, `box_group_boxes`

All associations use `dependent: :destroy` to clean up orphaned records.

### Image Storage Pattern

Images are stored as binary data directly in the database (not using Active Storage). Controllers handle image uploads manually:

- `attach_uploaded_images` method processes uploads
- `remove_marked_images` handles deletions via `remove_image_ids` parameter
- Images served through ImagesController#show with proper content-type headers

### Key Controller Patterns

**BoxesController** - Standard CRUD with custom image handling on create/update

**BoxGroupsController** - CRUD plus:
- `add_box` (POST /box_groups/:id/add_box) - Add individual box to group
- `remove_box` (DELETE /box_groups/:id/remove_box) - Remove box from group
- `bulk_add` (POST /box_groups/bulk_add) - Add multiple boxes to existing or new group

**QrCodesController** - Generates PNG QR codes linking to box detail pages using rqrcode gem

### Markdown Rendering

Box contents use Redcarpet for markdown rendering with these extensions enabled:
- tables, fenced_code_blocks, autolink, strikethrough, underline, highlight, quote
- superscript, footnotes, disable_indented_code_blocks

Rendering helper is in `app/helpers/boxes_helper.rb`.

### Bulk Operations UI

The boxes index page includes JavaScript-enhanced bulk operations:
- Checkboxes to select multiple boxes
- Progressive disclosure for "add to new group" fields
- Single action to add boxes to existing or new group

## Technology Stack

- **Rails**: 8.1.0
- **Ruby**: 3.2.1
- **Database**: SQLite3 (development/test), multi-database setup in production
- **Frontend**: Hotwire (Turbo + Stimulus), Importmap
- **Key gems**: rqrcode (QR codes), redcarpet (markdown), image_processing
- **Testing**: Minitest with Capybara/Selenium for system tests
- **Solid gems**: solid_cache, solid_queue, solid_cable (database-backed adapters)

## Deployment (Dokku)

The application is deployed to a Dokku server at `boxes.mcpolemic.com`.

### Initial Setup (already completed)
```bash
# On server
dokku apps:create box-tracker
dokku domains:add box-tracker boxes.mcpolemic.com
dokku config:set box-tracker SECRET_KEY_BASE=$(openssl rand -hex 64)
dokku config:set box-tracker RAILS_ENV=production
dokku letsencrypt:enable box-tracker

# Locally
git remote add dokku dokku@142.93.186.183:box-tracker
```

### Deploying
```bash
git push dokku main:main   # Manual deploy
# Or push to GitHub main branch - GitHub Actions will auto-deploy
```

### Managing the App
```bash
# View logs
dokku logs box-tracker -t

# Check app status
dokku ps:report box-tracker

# Run Rails commands
dokku run box-tracker rails console
dokku run box-tracker rails db:migrate

# Environment variables
dokku config:show box-tracker
dokku config:set box-tracker KEY=value
```

### GitHub Actions Deploy

The `.github/workflows/deploy.yml` workflow automatically deploys on push to main. It requires the `DOKKU_SSH_PRIVATE_KEY` secret to be set in the repository settings.

## Test Patterns

- Tests use fixtures (located in `test/fixtures/`)
- Controller tests verify CRUD operations with and without images using `fixture_file_upload`
- Parallel test execution is enabled by default
- Assertions check model counts, redirects, flash messages, and view content

defmodule TestAppWeb.Examples.TemplatingLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Custom Rendering — keen_web_multiselect")}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="✨"
      title="Custom Rendering"
      subtitle="Fully customize options, badges, and selected items using render callbacks with HTML or DOM elements"
    >
      <.note title="Why this page uses inline scripts">
        Render callbacks must be JavaScript functions — they can't round-trip through HTML attributes.
        Each multiselect below gets its <code>.options</code> and render callbacks assigned via a small
        page script after the custom element upgrades.
      </.note>

      <.card title="Option Rendering Examples">
        <p>
          These examples demonstrate <code>renderOptionContentCallback</code>
          for customizing how options appear in the dropdown.
        </p>

        <h3>1. Framework Selector with Descriptions</h3>
        <.form_group>
          <label for="frameworks">Select Frameworks</label>
          <.web_multiselect id="frameworks" option_height={75} />
          <small class="form-text">Multi-line options with framework descriptions, star counts, and badges</small>
        </.form_group>

        <h3>2. Rich Product List</h3>
        <.form_group>
          <label for="products">Select Products</label>
          <.web_multiselect id="products" option_height={80} />
          <small class="form-text">
            Product cards with descriptions, ratings, prices, and stock status.
            Uses <code>getBadgeClassCallback</code>
            for dynamic price-based badge colors (Budget: green, Mid-Range: blue, Premium: pink).
            Price badges in dropdown options also color-coded based on price ranges.
          </small>
        </.form_group>

        <h3>3. Article/Blog Post Selector</h3>
        <.form_group>
          <label for="articles">Select Articles</label>
          <.web_multiselect id="articles" option_height={75} />
          <small class="form-text">Rich content with title, excerpt, author, and read time</small>
        </.form_group>

        <h3>4. Job Listing Selector</h3>
        <.form_group>
          <label for="jobs">Select Jobs</label>
          <.web_multiselect id="jobs" option_height={80} />
          <small class="form-text">Job cards with company, salary, location, and tech stack</small>
        </.form_group>

        <h3>5. Movie/Media Selector</h3>
        <.form_group>
          <label for="movies">Select Movies</label>
          <.web_multiselect id="movies" option_height={85} />
          <small class="form-text">Movie details with genre, rating, year, and synopsis</small>
        </.form_group>

        <h3>6. Image/File Picker</h3>
        <.form_group>
          <label for="images">Select Images</label>
          <.web_multiselect id="images" option_height={70} badges_threshold={2} badges_threshold_mode="count" />
          <small class="form-text">
            Image thumbnails with filename, dimensions, and file size. Shows max 2 badges then "+N more".
          </small>
        </.form_group>
      </.card>

      <.card title="Badge Rendering Examples">
        <p>
          These examples demonstrate <code>renderBadgeContentCallback</code>
          for customizing selected item badges.
        </p>

        <h3>7. User Selector with Avatars</h3>
        <.form_group>
          <label for="users">Select Team Members</label>
          <.web_multiselect id="users" />
          <small class="form-text">Compact badges in main area, detailed badges in popover</small>
        </.form_group>

        <h3>8. Tags with Icons</h3>
        <.form_group>
          <label for="tags">Select Tags</label>
          <.web_multiselect id="tags" />
          <small class="form-text">Badges with category icons and colors</small>
        </.form_group>
      </.card>

      <.card title="Single-Select Custom Rendering">
        <p>
          These examples demonstrate <code>renderSelectedContentCallback</code>
          for customizing the selected value text in single-select mode.
        </p>

        <h3>9. Person Selector (First Name Only When Closed)</h3>
        <.form_group>
          <label for="person">Select Person</label>
          <.web_multiselect id="person" multiple={false} />
          <small class="form-text">Shows full name in dropdown, first name only when closed</small>
        </.form_group>

        <h3>10. Country Code (Abbreviation When Closed)</h3>
        <.form_group>
          <label for="country">Select Country</label>
          <.web_multiselect id="country" multiple={false} />
          <small class="form-text">Shows full country name in dropdown, code when closed</small>
        </.form_group>
      </.card>

      <.card title="Combined Callbacks">
        <p>
          Examples demonstrating how to combine multiple rendering callbacks for sophisticated customization.
          These examples show how <code>renderOptionContentCallback</code>
          and <code>renderBadgeContentCallback</code>
          work together to create different displays for the same data in different contexts (dropdown vs badges vs popover).
        </p>

        <h3>11. Context-Aware Rendering</h3>
        <.form_group>
          <label for="contextual">Select Projects</label>
          <.web_multiselect
            id="contextual"
            option_height={80}
            badges_threshold={3}
            badges_threshold_mode="partial"
            enable_badge_tooltips={true}
          />
          <small class="form-text">
            Combines 3 callbacks: <code>renderOptionContentCallback</code>
            (rich dropdown with status, priority, tags),
            <code>renderBadgeContentCallback</code>
            (compact "▶️ Name" in main area, detailed "▶️ Name [priority]" in popover using <code>context.isInPopover</code>),
            and <code>getBadgeDisplayCallback</code>
            (plain text "Name - status (priority)" for tooltips).
          </small>
        </.form_group>

        <h3>12. Priority-Based Badge Styling</h3>
        <.form_group>
          <label for="priority-badges">Select Tasks</label>
          <.web_multiselect
            id="priority-badges"
            option_height={60}
            badges_threshold={2}
            badges_threshold_mode="count"
            show_counter={true}
          />
          <small class="form-text">
            Uses <code>renderBadgeContentCallback</code>
            for compact badge display and <code>renderSelectedItemContentCallback</code>
            for detailed popover display.
            Uses <code>getBadgeClassCallback</code>
            to add priority-based CSS classes (badge-urgent, badge-important, badge-normal, badge-low).
            Uses <code>customStylesCallback</code>
            to inject CSS into Shadow DOM for styling those classes.
            Demonstrates separate callbacks for badges vs. selected items popover and solving Shadow DOM CSS isolation.
          </small>
        </.form_group>
      </.card>

      <.card title="Advanced Layout Examples">
        <p>Examples demonstrating flex/grid layouts with checkbox alignment control.</p>

        <h3>13. Grid Layout with Centered Checkboxes</h3>
        <.form_group>
          <label for="grid-layout">Product Comparison Grid</label>
          <.web_multiselect id="grid-layout" checkbox_align="center" option_height={90} />
          <small class="form-text">CSS Grid layout with 2-column spec comparison, checkboxes centered</small>
        </.form_group>

        <h3>14. Flex Layout with Top-Aligned Checkboxes</h3>
        <.form_group>
          <label for="flex-layout">Notification Settings</label>
          <.web_multiselect id="flex-layout" checkbox_align="top" option_height={75} />
          <small class="form-text">Flexbox layout showing setting details with icons and badges</small>
        </.form_group>

        <h3>15. Large Checkbox Scale Example</h3>
        <.form_group>
          <label for="large-checkbox">Important Agreements</label>
          <.web_multiselect id="large-checkbox" option_height={60} />
          <small class="form-text">Larger checkboxes (1.5x scale) for better visibility and accessibility</small>
        </.form_group>
      </.card>

      <style>
        /* Custom styles for rendered content */
        .framework-card { display: flex; align-items: center; gap: 0.75rem; }
        .framework-icon { font-size: 1.5rem; }
        .framework-details { flex: 1; }
        .framework-name { font-weight: 600; color: #333; }
        .framework-meta { font-size: 0.875rem; color: #666; margin-top: 0.125rem; }

        .badge { display: inline-block; padding: 0.125rem 0.5rem; border-radius: 12px; font-size: 0.75rem; font-weight: 600; margin-left: 0.5rem; }
        .badge-new { background: #10b981; color: white; }
        .badge-trending { background: #f59e0b; color: white; }
        .badge-popular { background: #3b82f6; color: white; }

        .user-badge { display: flex; align-items: center; gap: 0.5rem; }
        .user-avatar { font-size: 1.25rem; }
        .user-details { display: flex; flex-direction: column; }
        .user-name { font-weight: 500; line-height: 1.2; }
        .user-role { font-size: 0.75rem; color: #666; line-height: 1.2; }

        .status-indicator { display: inline-block; width: 8px; height: 8px; border-radius: 50%; margin-right: 0.5rem; }
        .status-online { background: #10b981; }
        .status-offline { background: #ef4444; }

        .product-layout { display: flex; align-items: center; gap: 0.75rem; }
        .product-image { width: 40px; height: 40px; border-radius: 6px; object-fit: cover; background: #f0f0f0; }
        .product-info { flex: 1; }
        .product-name { font-weight: 500; color: #333; }
        .product-price { font-size: 0.875rem; color: #10b981; font-weight: 600; }
        .product-stock { font-size: 0.75rem; color: #666; }

        .tag { display: inline-block; background: #e5e7eb; color: #374151; padding: 0.125rem 0.5rem; border-radius: 3px; font-size: 0.75rem; margin-right: 0.25rem; margin-top: 0.25rem; }
        .tags-container { margin-top: 0.375rem; }

        /* Custom checkbox sizing for example #15 */
        #large-checkbox { --ml-checkbox-scale: 1.5; --ml-checkbox-margin-top: 0; }
      </style>

      <script type="module">
        const wait = (id) => new Promise((resolve) => {
          const check = () => {
            const el = document.getElementById(id);
            if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
            else requestAnimationFrame(check);
          };
          check();
        });

        // 1. Framework Selector with Descriptions
        wait('frameworks').then((frameworks) => {
          frameworks.options = [
              { id: 1, name: 'React', description: 'A JavaScript library for building user interfaces', stars: 220000, trending: true },
              { id: 2, name: 'Vue', description: 'The Progressive JavaScript Framework', stars: 207000, trending: false },
              { id: 3, name: 'Angular', description: 'Platform for building mobile and desktop web applications', stars: 94000, trending: false },
              { id: 4, name: 'Svelte', description: 'Cybernetically enhanced web apps', stars: 76000, trending: true },
              { id: 5, name: 'Solid', description: 'Simple and performant reactivity for building UIs', stars: 30000, trending: true },
              { id: 6, name: 'Qwik', description: 'Resumable framework for instant-loading web apps', stars: 20000, trending: true }
          ];

          frameworks.valueMember = 'id';
          frameworks.displayValueMember = 'name';

          frameworks.renderOptionContentCallback = (item, context) => {
              const starCount = (item.stars / 1000).toFixed(0);
              return `
                  <div style="display: grid; grid-template-columns: auto 1fr auto; grid-template-rows: auto auto; gap: 0.25rem 0.75rem; align-items: center; width: 100%;">
                      <span style="grid-row: 1 / 3; font-size: 1.25rem; align-self: center;">${item.trending ? '🔥' : '⭐'}</span>
                      <strong style="grid-row: 1; grid-column: 2; font-size: 1rem;">${item.name}</strong>
                      <span style="grid-row: 1 / 3; grid-column: 3; font-size: 0.875rem; color: #666; align-self: center; white-space: nowrap;">${starCount}k stars</span>
                      <div style="grid-row: 2; grid-column: 2; font-size: 0.875rem; color: #666; line-height: 1.4;">
                          ${item.description}
                      </div>
                  </div>
              `;
          };
        });

        // 2. Rich Product List
        wait('products').then((products) => {
          products.options = [
              { id: 1, name: 'Wireless Mouse', description: 'Ergonomic design with 6 programmable buttons', price: 29.99, rating: 4.8, stock: 45, category: 'Electronics' },
              { id: 2, name: 'Mechanical Keyboard', description: 'RGB backlit with Cherry MX switches', price: 89.99, rating: 4.9, stock: 12, category: 'Electronics' },
              { id: 3, name: 'USB-C Cable', description: '100W fast charging, 10Gbps data transfer', price: 12.99, rating: 4.5, stock: 200, category: 'Accessories' },
              { id: 4, name: 'Laptop Stand', description: 'Aluminum adjustable height desk stand', price: 39.99, rating: 4.7, stock: 0, category: 'Accessories' },
              { id: 5, name: 'Webcam HD', description: '1080p with auto-focus and noise cancellation', price: 59.99, rating: 4.6, stock: 8, category: 'Electronics' }
          ];

          products.valueMember = 'id';
          products.displayValueMember = 'name';

          products.renderOptionContentCallback = (item, context) => {
              const stockStatus = item.stock === 0 ? 'Out of stock' : `${item.stock} in stock`;
              const stockColor = item.stock === 0 ? '#ef4444' : item.stock < 20 ? '#f59e0b' : '#10b981';
              const stars = '★'.repeat(Math.floor(item.rating)) + (item.rating % 1 >= 0.5 ? '½' : '');

              // Dynamic badge based on price
              const getPriceBadge = (price) => {
                  if (price < 20) return { text: 'Budget', class: 'price-budget' };
                  if (price < 50) return { text: 'Mid-Range', class: 'price-mid' };
                  return { text: 'Premium', class: 'price-premium' };
              };
              const priceBadge = getPriceBadge(item.price);

              return `
                  <div style="display: flex; gap: 0.75rem; align-items: center;">
                      <div style="width: 50px; height: 50px; border-radius: 8px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); flex-shrink: 0;">
                          <div style="color: white; text-align: center; line-height: 50px; font-size: 1.5rem;">
                              ${item.name.charAt(0)}
                          </div>
                      </div>
                      <div style="flex: 1; min-width: 0;">
                          <div style="font-weight: 600; margin-bottom: 0.125rem;">
                              ${item.name}
                              <span class="${priceBadge.class}" style="margin-left: 0.5rem; font-size: 0.7rem; padding: 0.125rem 0.375rem; border-radius: 0.25rem; font-weight: 600;">${priceBadge.text}</span>
                          </div>
                          <div style="font-size: 0.875rem; color: #666; margin-bottom: 0.25rem; line-height: 1.3;">${item.description}</div>
                          <div style="display: flex; align-items: center; gap: 0.75rem; font-size: 0.875rem;">
                              <span style="color: #10b981; font-weight: 600;">$${item.price}</span>
                              <span style="color: #f59e0b;">${stars} ${item.rating}</span>
                              <span style="color: ${stockColor};">${stockStatus}</span>
                          </div>
                      </div>
                  </div>
              `;
          };

          // Add dynamic CSS classes to badges based on price
          products.getBadgeClassCallback = (item) => {
              if (item.price < 20) return 'product-budget';
              if (item.price < 50) return 'product-mid';
              return 'product-premium';
          };

          // Inject CSS for price-based styling
          products.customStylesCallback = () => `
              /* Price badge styles in options */
              .price-budget {
                  background-color: #d1fae5;
                  color: #059669;
              }
              .price-mid {
                  background-color: #dbeafe;
                  color: #2563eb;
              }
              .price-premium {
                  background-color: #fce7f3;
                  color: #be185d;
              }

              /* Badge styles based on price */
              .product-budget {
                  --ms-badge-text-background: #d1fae5;
                  --ms-badge-text-color: #059669;
                  --ms-badge-remove-background: #059669;
              }
              .product-mid {
                  --ms-badge-text-background: #dbeafe;
                  --ms-badge-text-color: #2563eb;
                  --ms-badge-remove-background: #2563eb;
              }
              .product-premium {
                  --ms-badge-text-background: #fce7f3;
                  --ms-badge-text-color: #be185d;
                  --ms-badge-remove-background: #be185d;
              }
          `;

          products.getDisabledCallback = (item) => item.stock === 0;
        });

        // 3. Article/Blog Post Selector
        wait('articles').then((articles) => {
          articles.options = [
              { id: 1, title: 'Getting Started with TypeScript', excerpt: 'Learn the basics of TypeScript and how to integrate it into your projects...', author: 'John Doe', readTime: '5 min', date: 'Mar 15, 2024', icon: '📝' },
              { id: 2, title: 'Advanced React Patterns', excerpt: 'Explore compound components, render props, and custom hooks for better code...', author: 'Jane Smith', readTime: '8 min', date: 'Mar 10, 2024', icon: '⚛️' },
              { id: 3, title: 'CSS Grid Layout Guide', excerpt: 'Master CSS Grid with practical examples and real-world layouts...', author: 'Bob Johnson', readTime: '6 min', date: 'Mar 5, 2024', icon: '🎨' },
              { id: 4, title: 'Web Performance Tips', excerpt: 'Optimize your website for speed with lazy loading, code splitting, and more...', author: 'Alice Williams', readTime: '7 min', date: 'Feb 28, 2024', icon: '⚡' },
              { id: 5, title: 'API Design Best Practices', excerpt: 'Build robust and developer-friendly REST APIs with proper versioning and docs...', author: 'Charlie Brown', readTime: '10 min', date: 'Feb 20, 2024', icon: '🔌' }
          ];

          articles.valueMember = 'id';
          articles.displayValueMember = 'title';

          articles.renderOptionContentCallback = (item, context) => {
              return `
                  <div style="display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto auto auto; gap: 0.25rem 0.75rem; width: 100%;">
                      <span style="grid-row: 1 / 4; font-size: 1.25rem; align-self: center;">${item.icon}</span>
                      <strong style="grid-row: 1; grid-column: 2;">${item.title}</strong>
                      <div style="grid-row: 2; grid-column: 2; font-size: 0.875rem; color: #666; line-height: 1.4;">
                          ${item.excerpt}
                      </div>
                      <div style="grid-row: 3; grid-column: 2; font-size: 0.75rem; color: #999; display: flex; gap: 0.75rem;">
                          <span>By ${item.author}</span>
                          <span>•</span>
                          <span>${item.readTime} read</span>
                          <span>•</span>
                          <span>${item.date}</span>
                      </div>
                  </div>
              `;
          };
        });

        // 4. Job Listing Selector
        wait('jobs').then((jobs) => {
          jobs.options = [
              { id: 1, title: 'Senior Frontend Developer', company: 'TechCorp', location: 'Remote', salary: '$120k-150k', type: 'Full-time', tags: ['React', 'TypeScript', 'Node.js'], posted: '2 days ago' },
              { id: 2, title: 'Backend Engineer', company: 'StartupXYZ', location: 'San Francisco', salary: '$130k-160k', type: 'Full-time', tags: ['Python', 'Django', 'PostgreSQL'], posted: '1 week ago' },
              { id: 3, title: 'Full Stack Developer', company: 'WebAgency', location: 'New York', salary: '$100k-130k', type: 'Full-time', tags: ['Vue', 'Laravel', 'MySQL'], posted: '3 days ago' },
              { id: 4, title: 'DevOps Engineer', company: 'CloudServices', location: 'Remote', salary: '$140k-170k', type: 'Contract', tags: ['AWS', 'Docker', 'Kubernetes'], posted: '5 days ago' },
              { id: 5, title: 'UI/UX Designer', company: 'DesignStudio', location: 'London', salary: '£60k-80k', type: 'Part-time', tags: ['Figma', 'Sketch', 'Prototyping'], posted: '1 day ago' }
          ];

          jobs.valueMember = 'id';
          jobs.displayValueMember = 'title';

          jobs.renderOptionContentCallback = (item, context) => {
              return `
                  <div style="display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto auto auto; gap: 0.375rem 0.75rem; width: 100%;">
                      <span style="grid-row: 1 / 4; font-size: 1.25rem; align-self: center;">💼</span>
                      <div style="grid-row: 1; grid-column: 2;">
                          <div style="font-weight: 600; margin-bottom: 0.125rem;">${item.title}</div>
                          <div style="font-size: 0.875rem; color: #666;">${item.company}</div>
                      </div>
                      <div style="grid-row: 2; grid-column: 2; font-size: 0.875rem; color: #333; display: flex; gap: 0.75rem; flex-wrap: wrap;">
                          <span>${item.location}</span>
                          <span>•</span>
                          <span style="color: #10b981; font-weight: 600;">${item.salary}</span>
                          <span>•</span>
                          <span>${item.type}</span>
                      </div>
                      <div style="grid-row: 3; grid-column: 2;">
                          ${item.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
                      </div>
                  </div>
              `;
          };
        });

        // 5. Movie/Media Selector
        wait('movies').then((movies) => {
          movies.options = [
              { id: 1, title: 'The Matrix', year: 1999, genre: 'Sci-Fi, Action', rating: 8.7, synopsis: 'A computer hacker learns about the true nature of his reality and his role in the war against its controllers.', director: 'Wachowskis' },
              { id: 2, title: 'Inception', year: 2010, genre: 'Sci-Fi, Thriller', rating: 8.8, synopsis: 'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.', director: 'Christopher Nolan' },
              { id: 3, title: 'The Shawshank Redemption', year: 1994, genre: 'Drama', rating: 9.3, synopsis: 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', director: 'Frank Darabont' },
              { id: 4, title: 'Pulp Fiction', year: 1994, genre: 'Crime, Drama', rating: 8.9, synopsis: 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.', director: 'Quentin Tarantino' },
              { id: 5, title: 'The Dark Knight', year: 2008, genre: 'Action, Crime', rating: 9.0, synopsis: 'When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest psychological tests.', director: 'Christopher Nolan' }
          ];

          movies.valueMember = 'id';
          movies.displayValueMember = 'title';

          movies.renderOptionContentCallback = (item, context) => {
              const stars = '★'.repeat(Math.floor(item.rating)) + (item.rating % 1 >= 0.5 ? '½' : '');
              return `
                  <div style="display: grid; grid-template-columns: 1fr auto; gap: 0.5rem; width: 100%;">
                      <div style="display: flex; flex-direction: column; gap: 0.375rem;">
                          <div>
                              <strong style="font-size: 1rem;">🎬 ${item.title}</strong>
                              <span style="color: #666; font-size: 0.875rem; margin-left: 0.5rem;">(${item.year})</span>
                          </div>
                          <div style="font-size: 0.875rem; color: #666;">
                              ${item.genre} • Dir. ${item.director}
                          </div>
                          <div style="font-size: 0.875rem; color: #666; line-height: 1.4;">
                              ${item.synopsis}
                          </div>
                      </div>
                      <div style="color: #f59e0b; font-size: 0.875rem; white-space: nowrap;">
                          ${stars} ${item.rating}/10
                      </div>
                  </div>
              `;
          };
        });

        // 6. Image/File Picker
        wait('images').then((images) => {
          images.options = [
              { id: 1, filename: 'hero-banner.jpg', width: 1920, height: 1080, size: 2456000, type: 'image/jpeg', thumbnail: 'https://picsum.photos/seed/hero/60/60' },
              { id: 2, filename: 'product-photo.png', width: 800, height: 800, size: 1234000, type: 'image/png', thumbnail: 'https://picsum.photos/seed/product/60/60' },
              { id: 3, filename: 'team-photo.jpg', width: 1600, height: 900, size: 3120000, type: 'image/jpeg', thumbnail: 'https://picsum.photos/seed/team/60/60' },
              { id: 4, filename: 'logo-dark.svg', width: 200, height: 60, size: 8500, type: 'image/svg+xml', thumbnail: null },
              { id: 5, filename: 'background-pattern.png', width: 400, height: 400, size: 156000, type: 'image/png', thumbnail: 'https://picsum.photos/seed/pattern/60/60' },
              { id: 6, filename: 'icon-set.svg', width: 24, height: 24, size: 12400, type: 'image/svg+xml', thumbnail: null },
              { id: 7, filename: 'screenshot-app.png', width: 1440, height: 900, size: 890000, type: 'image/png', thumbnail: 'https://picsum.photos/seed/app/60/60' }
          ];

          images.valueMember = 'id';
          images.displayValueMember = 'filename';

          // Format file size
          const formatFileSize = (bytes) => {
              if (bytes < 1024) return bytes + ' B';
              if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
              return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
          };

          // Get file type icon
          const getFileIcon = (type) => {
              if (type === 'image/svg+xml') return '📐';
              if (type === 'image/png') return '🖼️';
              return '📷';
          };

          images.renderOptionContentCallback = (item, context) => {
              const icon = getFileIcon(item.type);
              const fileSize = formatFileSize(item.size);
              const dimensions = `${item.width} × ${item.height}`;

              // Use thumbnail if available, otherwise show colored placeholder
              const thumbnailHtml = item.thumbnail
                  ? `<img src="${item.thumbnail}" style="width: 50px; height: 50px; border-radius: 6px; object-fit: cover;">`
                  : `<div style="width: 50px; height: 50px; border-radius: 6px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">${icon}</div>`;

              return `
                  <div style="display: flex; gap: 0.75rem; align-items: center;">
                      ${thumbnailHtml}
                      <div style="flex: 1; min-width: 0;">
                          <div style="font-weight: 500; margin-bottom: 0.25rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                              ${icon} ${item.filename}
                          </div>
                          <div style="display: flex; gap: 1rem; font-size: 0.8rem; color: #666;">
                              <span>${dimensions}</span>
                              <span style="color: #10b981; font-weight: 500;">${fileSize}</span>
                              <span style="color: #999;">${item.type.split('/')[1].toUpperCase()}</span>
                          </div>
                      </div>
                  </div>
              `;
          };

          images.renderBadgeContentCallback = (item, context) => {
              const icon = getFileIcon(item.type);
              return `${icon} ${item.filename}`;
          };

          // Rich rendering for Selected Items popover
          images.renderSelectedItemContentCallback = (item) => {
              const icon = getFileIcon(item.type);
              const fileSize = formatFileSize(item.size);
              const dimensions = `${item.width} × ${item.height}`;

              const thumbnailHtml = item.thumbnail
                  ? `<img src="${item.thumbnail}" style="width: 36px; height: 36px; border-radius: 4px; object-fit: cover;">`
                  : `<div style="width: 36px; height: 36px; border-radius: 4px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; font-size: 1rem;">${icon}</div>`;

              return `
                  <div style="display: flex; align-items: center; gap: 0.5rem; width: 100%;">
                      ${thumbnailHtml}
                      <div style="flex: 1; min-width: 0;">
                          <div style="font-weight: 500; font-size: 0.8rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${item.filename}</div>
                          <div style="font-size: 0.7rem; color: #666;">${dimensions} • ${fileSize}</div>
                      </div>
                  </div>
              `;
          };
        });

        // 7. User Selector with Avatars
        wait('users').then((users) => {
          users.options = [
              { id: 1, firstName: 'John', lastName: 'Doe', role: 'Admin', avatar: '👨‍💼', status: 'online' },
              { id: 2, firstName: 'Jane', lastName: 'Smith', role: 'Developer', avatar: '👩‍💻', status: 'online' },
              { id: 3, firstName: 'Bob', lastName: 'Johnson', role: 'Designer', avatar: '🎨', status: 'offline' },
              { id: 4, firstName: 'Alice', lastName: 'Williams', role: 'Manager', avatar: '👩‍💼', status: 'online' },
              { id: 5, firstName: 'Charlie', lastName: 'Brown', role: 'Developer', avatar: '👨‍💻', status: 'offline' }
          ];

          users.valueMember = 'id';
          users.getDisplayValueCallback = (item) => `${item.firstName} ${item.lastName}`;

          users.renderOptionContentCallback = (item, context) => {
              const statusClass = item.status === 'online' ? 'status-online' : 'status-offline';
              return `
                  <div style="display: flex; align-items: center; gap: 0.75rem;">
                      <span style="font-size: 1.5rem;">${item.avatar}</span>
                      <div style="flex: 1;">
                          <div style="font-weight: 500;">
                              <span class="status-indicator ${statusClass}"></span>
                              ${item.firstName} ${item.lastName}
                          </div>
                          <div style="font-size: 0.875rem; color: #666;">${item.role}</div>
                      </div>
                  </div>
              `;
          };

          users.renderBadgeContentCallback = (item, context) => {
              if (context.isInPopover) {
                  // Detailed view in popover
                  return `
                      <div class="user-badge">
                          <span class="user-avatar">${item.avatar}</span>
                          <div class="user-details">
                              <span class="user-name">${item.firstName} ${item.lastName}</span>
                              <span class="user-role">${item.role}</span>
                          </div>
                      </div>
                  `;
              } else {
                  // Compact view in badges
                  return `${item.avatar} ${item.firstName}`;
              }
          };
        });

        // 8. Tags with Icons
        wait('tags').then((tags) => {
          tags.options = [
              { id: 1, name: 'Bug', icon: '🐛', color: '#ef4444' },
              { id: 2, name: 'Feature', icon: '✨', color: '#10b981' },
              { id: 3, name: 'Documentation', icon: '📝', color: '#3b82f6' },
              { id: 4, name: 'Enhancement', icon: '🚀', color: '#8b5cf6' },
              { id: 5, name: 'Question', icon: '❓', color: '#f59e0b' }
          ];

          tags.valueMember = 'id';
          tags.displayValueMember = 'name';

          tags.renderBadgeContentCallback = (item, context) => {
              return `
                  <span style="display: inline-flex; align-items: center; gap: 0.375rem;">
                      <span>${item.icon}</span>
                      <span>${item.name}</span>
                  </span>
              `;
          };
        });

        // 9. Person Selector (Single-Select)
        wait('person').then((person) => {
          person.options = [
              { id: 1, firstName: 'John', lastName: 'Doe', email: 'john@example.com' },
              { id: 2, firstName: 'Jane', lastName: 'Smith', email: 'jane@example.com' },
              { id: 3, firstName: 'Bob', lastName: 'Johnson', email: 'bob@example.com' }
          ];

          person.valueMember = 'id';
          person.getDisplayValueCallback = (item) => `${item.firstName} ${item.lastName} (${item.email})`;
          person.renderSelectedContentCallback = (item) => item.firstName; // Just first name when closed
        });

        // 10. Country Code
        wait('country').then((country) => {
          country.options = [
              { code: 'US', name: 'United States', flag: '🇺🇸' },
              { code: 'GB', name: 'United Kingdom', flag: '🇬🇧' },
              { code: 'CA', name: 'Canada', flag: '🇨🇦' },
              { code: 'AU', name: 'Australia', flag: '🇦🇺' },
              { code: 'DE', name: 'Germany', flag: '🇩🇪' }
          ];

          country.valueMember = 'code';
          country.getDisplayValueCallback = (item) => `${item.flag} ${item.name}`;
          country.renderSelectedContentCallback = (item) => item.code; // Just code when closed
        });

        // 11. Context-Aware Rendering
        wait('contextual').then((contextual) => {
          contextual.options = [
              { id: 1, name: 'Website Redesign', status: 'active', priority: 'high', tags: ['design', 'frontend'] },
              { id: 2, name: 'Mobile App', status: 'planning', priority: 'medium', tags: ['mobile', 'react-native'] },
              { id: 3, name: 'API Development', status: 'active', priority: 'high', tags: ['backend', 'api'] },
              { id: 4, name: 'Database Migration', status: 'completed', priority: 'low', tags: ['database', 'devops'] },
              { id: 5, name: 'User Testing', status: 'planning', priority: 'medium', tags: ['ux', 'testing'] }
          ];

          contextual.valueMember = 'id';
          contextual.displayValueMember = 'name';

          contextual.renderOptionContentCallback = (item, context) => {
              const priorityColors = { high: '#ef4444', medium: '#f59e0b', low: '#10b981' };
              const statusIcons = { active: '▶️', planning: '📋', completed: '✅' };

              return `
                  <div>
                      <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                          <span>${statusIcons[item.status]}</span>
                          <strong style="${context.isFocused ? 'color: #667eea;' : ''}">${item.name}</strong>
                          <span style="font-size: 0.75rem; padding: 0.125rem 0.375rem; background: ${priorityColors[item.priority]}; color: white; border-radius: 3px; margin-left: auto;">
                              ${item.priority}
                          </span>
                      </div>
                      <div class="tags-container">
                          ${item.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
                      </div>
                  </div>
              `;
          };

          contextual.renderBadgeContentCallback = (item, context) => {
              const statusIcons = { active: '▶️', planning: '📋', completed: '✅' };
              const priorityColors = { high: '#ef4444', medium: '#f59e0b', low: '#10b981' };

              if (context.isInPopover) {
                  // In popover: Show full details with status icon and priority
                  return `
                      <div style="display: flex; align-items: center; gap: 0.5rem; width: 100%;">
                          <span>${statusIcons[item.status]}</span>
                          <span style="flex: 1;">${item.name}</span>
                          <span style="font-size: 0.65rem; padding: 0.125rem 0.25rem; background: ${priorityColors[item.priority]}; color: white; border-radius: 2px;">
                              ${item.priority}
                          </span>
                      </div>
                  `;
              } else {
                  // In main badges area: Compact with just status icon + name
                  return `
                      <span>${statusIcons[item.status]} ${item.name}</span>
                  `;
              }
          };

          contextual.getBadgeDisplayCallback = (item) => {
              // For tooltips: show full project details
              return `${item.name} - ${item.status} (${item.priority} priority)`;
          };
        });

        // 12. Priority-Based Badge Styling
        wait('priority-badges').then((priorityBadges) => {
          priorityBadges.options = [
              { id: 1, name: 'Fix critical security vulnerability', priority: 'urgent', dueDate: 'Today' },
              { id: 2, name: 'Implement user authentication', priority: 'urgent', dueDate: 'Tomorrow' },
              { id: 3, name: 'Update documentation', priority: 'important', dueDate: 'This week' },
              { id: 4, name: 'Refactor API endpoints', priority: 'important', dueDate: 'This week' },
              { id: 5, name: 'Add unit tests', priority: 'normal', dueDate: 'Next week' },
              { id: 6, name: 'Review pull requests', priority: 'normal', dueDate: 'Next week' },
              { id: 7, name: 'Update dependencies', priority: 'low', dueDate: 'Next month' },
              { id: 8, name: 'Clean up old branches', priority: 'low', dueDate: 'Next month' }
          ];

          priorityBadges.valueMember = 'id';
          priorityBadges.displayValueMember = 'name';

          priorityBadges.renderOptionContentCallback = (item, context) => {
              const priorityIcons = { urgent: '🚨', important: '⚠️', normal: '📋', low: '📝' };
              const priorityLabels = { urgent: 'URGENT', important: 'Important', normal: 'Normal', low: 'Low Priority' };

              return `
                  <div style="display: flex; align-items: center; gap: 0.5rem;">
                      <span style="font-size: 1.25rem;">${priorityIcons[item.priority]}</span>
                      <div style="flex: 1;">
                          <div style="font-weight: 500;">${item.name}</div>
                          <div style="font-size: 0.75rem; color: #666; margin-top: 0.125rem;">Due: ${item.dueDate}</div>
                      </div>
                      <span style="font-size: 0.75rem; font-weight: 600;">${priorityLabels[item.priority]}</span>
                  </div>
              `;
          };

          // Main badges area: Compact with just icon + name
          priorityBadges.renderBadgeContentCallback = (item, context) => {
              const priorityIcons = { urgent: '🚨', important: '⚠️', normal: '📋', low: '📝' };
              return `<span>${priorityIcons[item.priority]} ${item.name}</span>`;
          };

          // Selected items popover: Show full details with icon, name, due date, and priority label
          priorityBadges.renderSelectedItemContentCallback = (item) => {
              const priorityIcons = { urgent: '🚨', important: '⚠️', normal: '📋', low: '📝' };
              const priorityLabels = { urgent: 'URGENT', important: 'Important', normal: 'Normal', low: 'Low Priority' };

              return `
                  <div style="display: flex; align-items: center; gap: 0.5rem; width: 100%;">
                      <span style="font-size: 1rem;">${priorityIcons[item.priority]}</span>
                      <div style="flex: 1; min-width: 0;">
                          <div style="font-weight: 500; font-size: 0.875rem;">${item.name}</div>
                          <div style="font-size: 0.7rem; color: #666; margin-top: 0.125rem;">Due: ${item.dueDate}</div>
                      </div>
                      <span style="font-size: 0.65rem; font-weight: 600; white-space: nowrap;">${priorityLabels[item.priority]}</span>
                  </div>
              `;
          };

          priorityBadges.getBadgeClassCallback = (item) => {
              // Return CSS class based on priority for semantic styling (main badges area)
              return `badge-${item.priority}`;
          };

          priorityBadges.getSelectedItemClassCallback = (item) => {
              // Return CSS class based on priority for selected items in popover
              return `badge-${item.priority}`;
          };

          // Inject custom CSS into Shadow DOM for badge styling
          priorityBadges.customStylesCallback = () => `
              .badge-urgent {
                  --ms-badge-text-background: #fee2e2;
                  --ms-badge-text-color: #dc2626;
                  --ms-badge-remove-background: #dc2626;
              }

              .badge-important {
                  --ms-badge-text-background: #fef3c7;
                  --ms-badge-text-color: #d97706;
                  --ms-badge-remove-background: #d97706;
              }

              .badge-normal {
                  --ms-badge-text-background: #dbeafe;
                  --ms-badge-text-color: #2563eb;
                  --ms-badge-remove-background: #2563eb;
              }

              .badge-low {
                  --ms-badge-text-background: #d1fae5;
                  --ms-badge-text-color: #059669;
                  --ms-badge-remove-background: #059669;
              }
          `;
        });

        // 13. Grid Layout Example
        wait('grid-layout').then((gridLayout) => {
          gridLayout.options = [
              { id: 1, name: 'Premium Plan', price: '$99/mo', users: '50 users', storage: '1TB', support: '24/7 Priority', features: 'All features' },
              { id: 2, name: 'Business Plan', price: '$49/mo', users: '10 users', storage: '500GB', support: 'Email Support', features: 'Core features' },
              { id: 3, name: 'Starter Plan', price: '$19/mo', users: '3 users', storage: '100GB', support: 'Community', features: 'Basic features' },
              { id: 4, name: 'Enterprise', price: 'Custom', users: 'Unlimited', storage: 'Unlimited', support: 'Dedicated', features: 'Everything + Custom' }
          ];

          gridLayout.valueMember = 'id';
          gridLayout.displayValueMember = 'name';

          gridLayout.renderOptionContentCallback = (item, context) => {
              return `
                  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem 1.5rem; width: 100%;">
                      <div style="font-weight: 600; font-size: 1.05rem; grid-column: 1 / -1; margin-bottom: 0.25rem;">
                          ${item.name} <span style="color: #10b981; font-weight: 700;">${item.price}</span>
                      </div>
                      <div style="display: flex; flex-direction: column; gap: 0.25rem;">
                          <span style="font-size: 0.875rem;"><strong>Users:</strong> ${item.users}</span>
                          <span style="font-size: 0.875rem;"><strong>Storage:</strong> ${item.storage}</span>
                      </div>
                      <div style="display: flex; flex-direction: column; gap: 0.25rem;">
                          <span style="font-size: 0.875rem;"><strong>Support:</strong> ${item.support}</span>
                          <span style="font-size: 0.875rem;"><strong>Features:</strong> ${item.features}</span>
                      </div>
                  </div>
              `;
          };
        });

        // 14. Flex Layout Example
        wait('flex-layout').then((flexLayout) => {
          flexLayout.options = [
              { id: 1, name: 'Email Notifications', description: 'Receive updates and alerts via email', frequency: 'Daily digest', icon: '📧', critical: true },
              { id: 2, name: 'Push Notifications', description: 'Get instant mobile push alerts', frequency: 'Real-time', icon: '🔔', critical: true },
              { id: 3, name: 'SMS Alerts', description: 'Important updates via text message', frequency: 'Weekly summary', icon: '💬', critical: false },
              { id: 4, name: 'In-App Messages', description: 'Notifications within the application', frequency: 'Instant', icon: '💭', critical: false },
              { id: 5, name: 'Desktop Notifications', description: 'Browser desktop notifications', frequency: 'Real-time', icon: '🖥️', critical: false }
          ];

          flexLayout.valueMember = 'id';
          flexLayout.displayValueMember = 'name';

          flexLayout.renderOptionContentCallback = (item, context) => {
              return `
                  <div style="display: flex; flex-direction: column; gap: 0.375rem; flex: 1;">
                      <div style="display: flex; justify-content: space-between; align-items: center;">
                          <div style="display: flex; align-items: center; gap: 0.5rem;">
                              <span style="font-size: 1.25rem;">${item.icon}</span>
                              <strong>${item.name}</strong>
                          </div>
                          ${item.critical ? '<span style="background: #ef4444; color: white; padding: 0.125rem 0.5rem; border-radius: 12px; font-size: 0.75rem; font-weight: 600;">Critical</span>' : ''}
                      </div>
                      <div style="font-size: 0.875rem; color: #666; line-height: 1.4;">${item.description}</div>
                      <div style="font-size: 0.75rem; color: #999; display: flex; align-items: center; gap: 0.375rem;">
                          <span style="background: #e5e7eb; color: #374151; padding: 0.125rem 0.5rem; border-radius: 3px;">${item.frequency}</span>
                      </div>
                  </div>
              `;
          };
        });

        // 15. Large Checkbox Example
        wait('large-checkbox').then((largeCheckbox) => {
          largeCheckbox.options = [
              { id: 1, name: 'I accept the Terms of Service', required: true, description: 'You must agree to continue' },
              { id: 2, name: 'I accept the Privacy Policy', required: true, description: 'Required for data processing' },
              { id: 3, name: 'I agree to receive marketing emails', required: false, description: 'Optional newsletter subscription' },
              { id: 4, name: 'I agree to data sharing with partners', required: false, description: 'Help us improve services' }
          ];

          largeCheckbox.valueMember = 'id';
          largeCheckbox.displayValueMember = 'name';

          largeCheckbox.renderOptionContentCallback = (item, context) => {
              return `
                  <div style="display: flex; flex-direction: column; gap: 0.25rem;">
                      <div style="display: flex; align-items: center; gap: 0.5rem;">
                          <strong style="font-size: 1.05rem;">${item.name}</strong>
                          ${item.required
                              ? '<span style="color: #ef4444; font-size: 0.875rem; font-weight: 600;">(Required)</span>'
                              : '<span style="color: #10b981; font-size: 0.875rem; font-weight: 600;">(Optional)</span>'
                          }
                      </div>
                      <div style="font-size: 0.875rem; color: #666;">${item.description}</div>
                  </div>
              `;
          };
        });
      </script>
    </.example_page>
    """
  end
end

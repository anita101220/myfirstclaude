const GITHUB_USER = 'anita101220';
const GITHUB_API = `https://api.github.com/users/${GITHUB_USER}/repos?sort=updated&per_page=6`;

const LANG_COLORS = {
  JavaScript: '#f1e05a',
  TypeScript: '#3178c6',
  PHP:        '#4F5D95',
  Python:     '#3572A5',
  HTML:       '#e34c26',
  CSS:        '#563d7c',
  Java:       '#b07219',
  'C#':       '#178600',
  Ruby:       '#701516',
  Go:         '#00ADD8',
};

async function loadGitHubRepos() {
  const section = document.getElementById('github');
  const grid = document.getElementById('github-projects');

  try {
    const res = await fetch(GITHUB_API, {
      headers: { Accept: 'application/vnd.github.v3+json' }
    });
    if (!res.ok) return;

    const repos = await res.json();
    const visible = repos.filter(r => !r.fork && !r.archived);
    if (!visible.length) return;

    grid.innerHTML = visible.map(repo => `
      <article class="project-card">
        <div class="project-card__header">
          <h3 class="project-card__title">
            <a href="${repo.html_url}" target="_blank" rel="noopener">${repo.name}</a>
          </h3>
        </div>
        ${repo.description ? `<p class="project-card__desc">${repo.description}</p>` : ''}
        <div class="project-card__meta">
          ${repo.language ? `
            <span>
              <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${LANG_COLORS[repo.language] || '#888'};margin-right:4px;vertical-align:middle;"></span>
              ${repo.language}
            </span>` : ''}
          ${repo.stargazers_count > 0 ? `<span>&#9733; ${repo.stargazers_count}</span>` : ''}
        </div>
        <div class="project-card__tags">
          ${(repo.topics || []).map(t => `<span class="tag">${t}</span>`).join('')}
        </div>
      </article>
    `).join('');

    section.removeAttribute('hidden');
  } catch (_) {
    /* Fail silently — visitors should never see a broken state */
  }
}

document.addEventListener('DOMContentLoaded', loadGitHubRepos);

---
layout: default
title: 글쓰기
permalink: /write/
---
<section class="write-page">
  <div class="write-head">
    <div>
      <div class="eyebrow">POST EDITOR</div>
      <h1>개발 공부 기록 작성</h1>
      <p>작성한 내용을 Markdown 글로 바로 저장할 수 있습니다. 카테고리를 선택하면 생성되는 MD 파일의 Jekyll 카테고리에 그대로 반영됩니다.</p>
    </div>
    <div class="write-actions">
      <button type="button" id="save-draft">임시 저장</button>
      <button type="button" id="download-post" class="primary">Markdown 저장</button>
    </div>
  </div>

  <div class="editor-grid">
    <section class="editor-panel">
      <div class="editor-meta">
        <input id="post-title" type="text" placeholder="게시글 제목">
        <div class="editor-row">
          <input id="post-date" type="date">
          <div class="category-control">
            <select id="post-category" aria-label="게시글 카테고리">
              <option value="Java">Java</option>
              <option value="Spring">Spring</option>
              <option value="Spring Core / DI / AOP">Spring Core / DI / AOP</option>
              <option value="JPA / MyBatis">JPA / MyBatis</option>
              <option value="MVC / REST API">MVC / REST API</option>
              <option value="Security / JWT / OAuth2">Security / JWT / OAuth2</option>
              <option value="테스트 / 품질 관리">테스트 / 품질 관리</option>
              <option value="Database">Database</option>
              <option value="PL/SQL">PL/SQL</option>
              <option value="React">React</option>
              <option value="기타">기타</option>
            </select>
            <button type="button" id="add-category" class="category-add">+ 카테고리 추가</button>
          </div>
        </div>
        <div id="new-category-row" class="new-category-row" hidden>
          <input id="new-category" type="text" placeholder="새 카테고리 이름">
          <button type="button" id="confirm-category">추가</button>
          <button type="button" id="cancel-category">취소</button>
        </div>
        <input id="post-tags" type="text" placeholder="태그: Java, Spring, JPA">
      </div>

      <div class="editor-toolbar" aria-label="서식 도구">
        <button type="button" data-action="bold"><strong>B</strong></button>
        <button type="button" data-action="underline"><u>U</u></button>
        <button type="button" data-action="heading">H2</button>
        <button type="button" data-action="code">{ }</button>
        <button type="button" data-action="quote">❝</button>
        <button type="button" data-action="list">• 목록</button>
        <button type="button" data-action="link">링크</button>
      </div>

      <textarea id="post-body" spellcheck="false" placeholder="공부한 내용을 작성하세요.\n\n## 실행 흐름\n\n여기에 내용을 입력합니다.\n\n코드 블록도 버튼으로 넣을 수 있습니다."></textarea>
    </section>

    <section class="preview-panel">
      <div class="preview-label">PREVIEW</div>
      <article class="post-content" id="post-preview"></article>
    </section>
  </div>

  <div class="write-note">
    <strong>저장 방식</strong>
    <span>카테고리를 선택하거나 직접 추가한 뒤 <b>Markdown 저장</b>을 누르면 Jekyll용 게시글 파일이 생성됩니다. 다운로드한 파일을 <code>_posts</code>에 넣으면 해당 카테고리로 게시됩니다.</span>
  </div>
</section>

<script>
(() => {
  const title = document.getElementById('post-title');
  const date = document.getElementById('post-date');
  const category = document.getElementById('post-category');
  const tags = document.getElementById('post-tags');
  const body = document.getElementById('post-body');
  const preview = document.getElementById('post-preview');
  const addCategory = document.getElementById('add-category');
  const newCategoryRow = document.getElementById('new-category-row');
  const newCategory = document.getElementById('new-category');
  const confirmCategory = document.getElementById('confirm-category');
  const cancelCategory = document.getElementById('cancel-category');
  const draftKey = 'zuzusnasna-study-draft';
  const categoryKey = 'zuzusnasna-post-categories';

  const today = new Date();
  date.value = today.toISOString().slice(0, 10);

  function escapeHtml(value) {
    return value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
  }

  function renderMarkdown(source) {
    const lines = source.replace(/\r/g, '').split('\n');
    let html = '';
    let inCode = false;
    let code = [];
    let listOpen = false;

    const inline = text => escapeHtml(text)
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
      .replace(/<u>(.*?)<\/u>/g, '<u>$1</u>')
      .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');

    const closeList = () => { if (listOpen) { html += '</ul>'; listOpen = false; } };

    lines.forEach(line => {
      if (line.trim().startsWith('```')) {
        if (inCode) {
          html += '<pre><code>' + escapeHtml(code.join('\n')) + '</code></pre>';
          code = [];
          inCode = false;
        } else {
          closeList();
          inCode = true;
        }
        return;
      }
      if (inCode) { code.push(line); return; }
      if (/^###\s+/.test(line)) { closeList(); html += '<h3>' + inline(line.replace(/^###\s+/, '')) + '</h3>'; return; }
      if (/^##\s+/.test(line)) { closeList(); html += '<h2>' + inline(line.replace(/^##\s+/, '')) + '</h2>'; return; }
      if (/^#\s+/.test(line)) { closeList(); html += '<h2>' + inline(line.replace(/^#\s+/, '')) + '</h2>'; return; }
      if (/^[-*]\s+/.test(line)) { if (!listOpen) { html += '<ul>'; listOpen = true; } html += '<li>' + inline(line.replace(/^[-*]\s+/, '')) + '</li>'; return; }
      closeList();
      if (/^>\s?/.test(line)) { html += '<blockquote>' + inline(line.replace(/^>\s?/, '')) + '</blockquote>'; return; }
      if (!line.trim()) return;
      html += '<p>' + inline(line) + '</p>';
    });
    closeList();
    if (inCode) html += '<pre><code>' + escapeHtml(code.join('\n')) + '</code></pre>';
    return html || '<p class="preview-empty">작성한 내용이 여기에 표시됩니다.</p>';
  }

  function updatePreview() {
    preview.innerHTML = renderMarkdown(body.value);
    localStorage.setItem(draftKey, JSON.stringify({title: title.value, date: date.value, category: category.value, tags: tags.value, body: body.value}));
  }

  function insertAround(before, after = before, placeholder = '내용') {
    const start = body.selectionStart;
    const end = body.selectionEnd;
    const selected = body.value.slice(start, end) || placeholder;
    body.setRangeText(before + selected + after, start, end, 'select');
    body.focus();
    updatePreview();
  }

  function addCategoryOption(name, selectIt = true) {
    const trimmed = name.trim();
    if (!trimmed) return false;
    const exists = Array.from(category.options).some(option => option.value.toLowerCase() === trimmed.toLowerCase());
    if (exists) {
      if (selectIt) category.value = trimmed;
      return false;
    }
    const option = document.createElement('option');
    option.value = trimmed;
    option.textContent = trimmed;
    category.appendChild(option);
    if (selectIt) category.value = trimmed;
    return true;
  }

  function loadCustomCategories() {
    try {
      const saved = JSON.parse(localStorage.getItem(categoryKey) || '[]');
      if (Array.isArray(saved)) saved.forEach(name => addCategoryOption(String(name), false));
    } catch (_) {}
  }

  function saveCustomCategories() {
    const builtIn = new Set(['Java', 'Spring', 'Spring Core / DI / AOP', 'JPA / MyBatis', 'MVC / REST API', 'Security / JWT / OAuth2', '테스트 / 품질 관리', 'Database', 'PL/SQL', 'React', '기타']);
    const custom = Array.from(category.options).map(option => option.value).filter(value => !builtIn.has(value));
    localStorage.setItem(categoryKey, JSON.stringify(custom));
  }

  addCategory.addEventListener('click', () => {
    newCategoryRow.hidden = false;
    newCategory.focus();
  });

  confirmCategory.addEventListener('click', () => {
    const name = newCategory.value.trim();
    if (!name) {
      newCategory.focus();
      return;
    }
    if (!addCategoryOption(name)) {
      alert('이미 있는 카테고리입니다.');
      newCategory.focus();
      newCategory.select();
      return;
    }
    saveCustomCategories();
    newCategory.value = '';
    newCategoryRow.hidden = true;
    updatePreview();
  });

  cancelCategory.addEventListener('click', () => {
    newCategory.value = '';
    newCategoryRow.hidden = true;
  });

  newCategory.addEventListener('keydown', event => {
    if (event.key === 'Enter') confirmCategory.click();
    if (event.key === 'Escape') cancelCategory.click();
  });

  document.querySelectorAll('.editor-toolbar button').forEach(button => button.addEventListener('click', () => {
    const action = button.dataset.action;
    if (action === 'bold') insertAround('**', '**', '강조할 내용');
    if (action === 'underline') insertAround('<u>', '</u>', '밑줄을 표시할 내용');
    if (action === 'heading') insertAround('## ', '', '제목');
    if (action === 'code') insertAround('```java\n', '\n```', 'System.out.println("hello");');
    if (action === 'quote') insertAround('> ', '', '인용 내용');
    if (action === 'list') insertAround('- ', '', '목록 내용');
    if (action === 'link') insertAround('[', '](https://example.com)', '링크 텍스트');
  }));

  [title, date, category, tags, body].forEach(input => input.addEventListener('input', updatePreview));
  category.addEventListener('change', updatePreview);

  document.getElementById('save-draft').addEventListener('click', () => {
    updatePreview();
    alert('현재 작성 내용이 이 브라우저에 임시 저장되었습니다.');
  });

  document.getElementById('download-post').addEventListener('click', () => {
    const postDate = date.value || new Date().toISOString().slice(0, 10);
    const safeTitle = (title.value || 'new-post').trim();
    const slug = safeTitle.toLowerCase().replace(/[^a-z0-9가-힣]+/g, '-').replace(/^-|-$/g, '') || 'new-post';
    const tagList = tags.value.split(',').map(tag => tag.trim()).filter(Boolean);
    const frontMatter = [
      '---',
      'layout: post',
      'title: "' + safeTitle.replace(/"/g, '\\"') + '"',
      'date: ' + postDate + ' 00:00:00 +0900',
      'categories: [' + category.value + ']',
      'tags: [' + tagList.join(', ') + ']',
      '---',
      ''
    ].join('\n');
    const blob = new Blob([frontMatter + body.value], {type: 'text/markdown;charset=utf-8'});
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = postDate + '-' + slug + '.md';
    link.click();
    URL.revokeObjectURL(link.href);
  });

  loadCustomCategories();

  const saved = localStorage.getItem(draftKey);
  if (saved) {
    try {
      const draft = JSON.parse(saved);
      title.value = draft.title || '';
      date.value = draft.date || date.value;
      if (draft.category && !Array.from(category.options).some(option => option.value === draft.category)) addCategoryOption(draft.category, false);
      category.value = draft.category || 'Java';
      tags.value = draft.tags || '';
      body.value = draft.body || '';
    } catch (_) {}
  }
  updatePreview();
})();
</script>
